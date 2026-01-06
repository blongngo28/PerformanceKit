//
//  PerformanceMonitor.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import SwiftUI
import Combine

/// Main performance monitor class that tracks CPU, FPS, and memory usage
@MainActor
public class PerformanceMonitor: ObservableObject {
    
    public static let shared = PerformanceMonitor()

       private init() {
           setupCalculator()
           subscribeToNotifications()
       }
    
    /// Visual style for the performance overlay
    public enum Style {
        case dark
        case light
        case custom(
            backgroundColor: Color,
            borderColor: Color,
            borderWidth: CGFloat,
            cornerRadius: CGFloat,
            textColor: Color
        )
    }
    
    /// Options for what information to display in the overlay
    public struct DisplayOptions: OptionSet, Sendable {
        public let rawValue: Int
        
        /// Show CPU usage and FPS
        public static let performance = DisplayOptions(rawValue: 1 << 0)
        
        /// Show memory usage
        public static let memory = DisplayOptions(rawValue: 1 << 1)
        
        /// Show application version
        public static let application = DisplayOptions(rawValue: 1 << 2)
        
        /// Show device model
        public static let device = DisplayOptions(rawValue: 1 << 3)
        
        /// Show system version
        public static let system = DisplayOptions(rawValue: 1 << 4)
        
        /// Default options: performance and memory
        public static let `default`: DisplayOptions = [.performance, .memory]
        
        /// All available options
        public static let all: DisplayOptions = [.performance, .memory, .application, .device, .system]
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
    /// Current performance report
    @Published public var currentReport: PerformanceReport?
    
    /// Optional delegate for performance updates
    public weak var delegate: PerformanceMonitorDelegate?
    
    private let performanceCalculator = PerformanceCalculator()
    private var isMonitoring = false
    
    private func setupCalculator() {
        performanceCalculator.onReport = { [weak self] report in
            DispatchQueue.main.async {
                self?.currentReport = report
                self?.delegate?.performanceMonitor(didReport: report)
            }
        }
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            if self?.isMonitoring == true {
                self?.performanceCalculator.start()
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            if self?.isMonitoring == true {
                self?.performanceCalculator.pause()
            }
        }
    }
    
    /// Starts monitoring performance
    public func start() {
        isMonitoring = true
        performanceCalculator.start()
    }
    
    /// Pauses monitoring performance
    public func pause() {
        isMonitoring = false
        performanceCalculator.pause()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
