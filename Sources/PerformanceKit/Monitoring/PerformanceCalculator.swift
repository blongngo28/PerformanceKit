//
//  PerformanceCalculator.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import QuartzCore
#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Internal performance calculator that handles low-level monitoring.
///
/// This class is responsible for:
/// - Tracking frame timings via CADisplayLink
/// - Calculating FPS using a sliding window
/// - Gathering CPU usage statistics via Mach APIs
/// - Collecting memory usage information
///
/// ## Note
/// This is an internal class and should not be used directly. Use `PerformanceMonitor`
/// for all performance monitoring needs.
internal class PerformanceCalculator {
    private struct Constants {
        static let accumulationTimeInSeconds = 1.0
    }
    
    /// Callback closure for receiving performance reports.
    internal var onReport: ((PerformanceReport) -> Void)?
    
    private var displayLink: CADisplayLink?
    private let linkedFramesList = LinkedFramesList()
    private var startTimestamp: TimeInterval?
    private var accumulatedInformationIsEnough = false
    
    /// Initializes the performance calculator.
    ///
    /// Sets up the CADisplayLink for frame timing and prepares for
    /// performance data collection.
    init() {
        configureDisplayLink()
    }
    
    /// Starts performance calculation.
    func start() {
        self.startTimestamp = Date().timeIntervalSince1970
        self.displayLink?.isPaused = false
    }
    
    /// Pauses performance calculation.
    func pause() {
        self.displayLink?.isPaused = true
        self.startTimestamp = nil
        self.accumulatedInformationIsEnough = false
    }
    
    private func configureDisplayLink() {
        #if os(macOS)
        self.displayLink = CADisplayLink(
            target: self,
            selector: #selector(displayLinkAction)
        )
        self.displayLink?.add(to: .main, forMode: .common)
        #else
        self.displayLink = CADisplayLink(
            target: self,
            selector: #selector(displayLinkAction)
        )
        self.displayLink?.add(to: .current, forMode: .common)
        #endif
        self.displayLink?.isPaused = true
    }
    
    @objc private func displayLinkAction(displayLink: CADisplayLink) {
        self.linkedFramesList.append(frameWithTimestamp: displayLink.timestamp)
        self.takePerformanceEvidence()
    }
    
    private func takePerformanceEvidence() {
        if self.accumulatedInformationIsEnough {
            let cpuUsage = self.cpuUsage()
            let fps = self.linkedFramesList.count
            let memoryUsage = self.memoryUsage()
            self.report(cpuUsage: cpuUsage, fps: fps, memoryUsage: memoryUsage)
        } else if let start = self.startTimestamp,
                  Date().timeIntervalSince1970 - start >= Constants.accumulationTimeInSeconds {
            self.accumulatedInformationIsEnough = true
        }
    }
    
    /// Calculates current CPU usage across all threads.
    ///
    /// This method uses Mach kernel APIs to gather thread information and
    /// calculate the total CPU usage percentage.
    ///
    /// - Returns: CPU usage as a percentage (0-100)
    private func cpuUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList: thread_act_array_t?
        var threadsCount = mach_msg_type_number_t(0)
        
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        
        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                guard infoResult == KERN_SUCCESS else {
                    break
                }
                
                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        
        if let threadsList = threadsList {
            vm_deallocate(
                mach_task_self_,
                vm_address_t(UInt(bitPattern: threadsList)),
                vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride)
            )
        }
        return totalUsageOfCPU
    }
    
    /// Calculates current memory usage.
    ///
    /// This method uses Mach kernel APIs to gather memory usage information
    /// for the current process.
    ///
    /// - Returns: A tuple containing used and total memory in bytes
    private func memoryUsage() -> MemoryUsage {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }
        
        let total = ProcessInfo.processInfo.physicalMemory
        return (used, total)
    }
    
    private func report(cpuUsage: Double, fps: Int, memoryUsage: MemoryUsage) {
        let performanceReport = (cpuUsage: cpuUsage, fps: fps, memoryUsage: memoryUsage)
        self.onReport?(performanceReport)
    }
    
    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }
}
