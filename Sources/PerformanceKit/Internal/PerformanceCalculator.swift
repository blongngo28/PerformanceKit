//
//  PerformanceCalculator.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import QuartzCore
import Foundation

/// Calculates performance metrics including CPU usage, FPS, and memory usage
internal class PerformanceCalculator {
    private struct Constants {
        static let accumulationTimeInSeconds = 1.0
    }
    
    /// Callback when new performance report is available
    internal var onReport: ((PerformanceReport) -> Void)?
    
    private var displayLink: CADisplayLink?
    private let linkedFramesList = LinkedFramesList()
    private var startTimestamp: TimeInterval?
    private var accumulatedInformationIsEnough = false
    
    init() {
        configureDisplayLink()
    }
    
    /// Starts performance monitoring
    func start() {
        startTimestamp = Date().timeIntervalSince1970
        displayLink?.isPaused = false
    }
    
    /// Pauses performance monitoring
    func pause() {
        displayLink?.isPaused = true
        startTimestamp = nil
        accumulatedInformationIsEnough = false
    }
    
    private func configureDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAction))
        displayLink?.isPaused = true
        displayLink?.add(to: .current, forMode: .common)
    }
    
    @objc private func displayLinkAction(displayLink: CADisplayLink) {
        linkedFramesList.append(frameWithTimestamp: displayLink.timestamp)
        takePerformanceEvidence()
    }
    
    private func takePerformanceEvidence() {
        if accumulatedInformationIsEnough {
            let cpuUsage = self.cpuUsage()
            let fps = linkedFramesList.count
            let memoryUsage = self.memoryUsage()
            report(cpuUsage: cpuUsage, fps: fps, memoryUsage: memoryUsage)
        } else if let start = startTimestamp,
                  Date().timeIntervalSince1970 - start >= Constants.accumulationTimeInSeconds {
            accumulatedInformationIsEnough = true
        }
    }
    
    /// Calculates current CPU usage across all threads
    /// - Returns: CPU usage percentage
    private func cpuUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList: thread_act_array_t?
        var threadsCount = mach_msg_type_number_t(0)
        
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        
        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(
                            threadsList[Int(index)],
                            thread_flavor_t(THREAD_BASIC_INFO),
                            $0,
                            &threadInfoCount
                        )
                    }
                }
                
                guard infoResult == KERN_SUCCESS else { break }
                
                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0)
                }
            }
        }
        
        vm_deallocate(
            mach_task_self_,
            vm_address_t(UInt(bitPattern: threadsList)),
            vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride)
        )
        
        return totalUsageOfCPU
    }
    
    /// Calculates current memory usage
    /// - Returns: Tuple containing used and total memory in bytes
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
        onReport?(performanceReport)
    }
    
    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }
}
