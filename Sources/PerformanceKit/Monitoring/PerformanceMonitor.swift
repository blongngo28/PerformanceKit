//
//  PerformanceMonitor.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import SwiftUI
import Combine
#if os(iOS)
import UIKit
#endif

/// Protocol for receiving performance monitoring updates.
///
/// Conform to this protocol to receive real-time performance reports when using
/// `PerformanceMonitor` programmatically.
///
/// ## Example
/// ```swift
/// class MyViewController: UIViewController, PerformanceMonitorDelegate {
///     override func viewDidLoad() {
///         super.viewDidLoad()
///         PerformanceMonitor.shared().delegate = self
///         PerformanceMonitor.shared().start()
///     }
///
///     func performanceMonitor(didReport performanceReport: PerformanceReport) {
///         print("CPU Usage: \(performanceReport.cpuUsage)%")
///         print("FPS: \(performanceReport.fps)")
///     }
/// }
/// ```
public protocol PerformanceMonitorDelegate: AnyObject {
    /// Called when a new performance report is generated.
    ///
    /// - Parameter performanceReport: The latest performance report containing
    ///   CPU usage, FPS, and memory usage information.
    func performanceMonitor(didReport performanceReport: PerformanceReport)
}

/// Main performance monitoring controller.
///
/// `PerformanceMonitor` is the central class for managing performance monitoring.
/// It provides both programmatic access to performance data and powers the overlay view.
/// Use the shared instance for most use cases, or create separate instances for
/// specialized monitoring scenarios.
///
/// ## Key Features
/// - Real-time performance monitoring
/// - Shared singleton instance for easy access
/// - Observable object for SwiftUI integration
/// - Lifecycle-aware monitoring (pauses when app enters background)
/// - Delegate pattern for programmatic updates
///
/// ## Usage Examples
///
/// ### Basic Usage with Shared Instance
/// ```swift
/// // Start monitoring
/// PerformanceMonitor.shared().start()
///
/// // Pause monitoring
/// PerformanceMonitor.shared().pause()
///
/// // Access current report
/// if let report = PerformanceMonitor.shared().currentReport {
///     print("Current FPS: \(report.fps)")
/// }
/// ```
///
/// ### Programmatic Monitoring with Delegate
/// ```swift
/// class PerformanceAnalyzer: PerformanceMonitorDelegate {
///     let monitor = PerformanceMonitor.shared()
///
///     init() {
///         monitor.delegate = self
///         monitor.start()
///     }
///
///     func performanceMonitor(didReport performanceReport: PerformanceReport) {
///         // Process performance data
///         analyzePerformance(performanceReport)
///     }
/// }
/// ```
///
/// ### SwiftUI Integration
/// ```swift
/// struct ContentView: View {
///     @StateObject private var monitor = PerformanceMonitor.shared()
///
///     var body: some View {
///         YourContentView()
///             .onAppear {
///                 monitor.start()
///             }
///             .onDisappear {
///                 monitor.pause()
///             }
///     }
/// }
/// ```
@MainActor
public class PerformanceMonitor: ObservableObject {
    /// Visual style options for the performance overlay.
    ///
    /// Use these styles to customize the appearance of the performance overlay
    /// to match your application's design.
    public enum Style: Hashable {
        /// Dark theme with black background and white text.
        case dark
        
        /// Light theme with white background and black text.
        case light
        
        /// Fully customizable theme with complete control over all visual aspects.
        ///
        /// - Parameters:
        ///   - backgroundColor: Background color of the overlay.
        ///   - borderColor: Color of the overlay border.
        ///   - borderWidth: Width of the overlay border.
        ///   - cornerRadius: Corner radius of the overlay.
        ///   - textColor: Color of the text within the overlay.
        case custom(
            backgroundColor: Color,
            borderColor: Color,
            borderWidth: CGFloat,
            cornerRadius: CGFloat,
            textColor: Color
        )
    }
    
    /// The latest performance report.
    ///
    /// This property is automatically updated with new performance data and
    /// can be observed in SwiftUI views. It's `nil` when no data has been
    /// collected yet or when monitoring is paused.
    @Published public private(set) var currentReport: PerformanceReport?
    
    /// Delegate to receive performance monitoring updates.
    ///
    /// Set this property to receive callbacks when new performance data is available.
    /// The delegate methods are called on the main thread.
    public weak var delegate: PerformanceMonitorDelegate?
    
    private let performanceCalculator = PerformanceCalculator()
    private var isMonitoring = false
    
    private static var sharedInstance: PerformanceMonitor?
    
    /// Initializes a new performance monitor instance.
    ///
    /// Creates a new `PerformanceMonitor` instance. For most use cases, it's recommended
    /// to use the shared instance via `PerformanceMonitor.shared()`.
    ///
    /// The monitor automatically subscribes to application lifecycle notifications
    /// to pause/resume monitoring appropriately.
    public init() {
        setupCalculator()
        subscribeToNotifications()
    }
    
    /// Returns the shared performance monitor instance.
    ///
    /// Use this shared instance for most monitoring scenarios to ensure consistent
    /// performance data across your application.
    ///
    /// - Returns: The shared `PerformanceMonitor` instance.
    public static func shared() -> PerformanceMonitor {
        if sharedInstance == nil {
            sharedInstance = PerformanceMonitor()
        }
        return sharedInstance!
    }
    
    private func setupCalculator() {
        performanceCalculator.onReport = { [weak self] report in
            DispatchQueue.main.async {
                self?.currentReport = report
                self?.delegate?.performanceMonitor(didReport: report)
            }
        }
    }
    
    private func subscribeToNotifications() {
        #if os(iOS)
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
        #endif
    }
    
    /// Starts performance monitoring.
    ///
    /// Call this method to begin collecting performance data. Monitoring will
    /// automatically pause when the application enters the background and resume
    /// when it returns to the foreground.
    ///
    /// ## Note
    /// - Monitoring begins after a 1-second warm-up period
    /// - The first report is available after warm-up completes
    /// - Reports are generated approximately once per second
    public func start() {
        isMonitoring = true
        performanceCalculator.start()
    }
    
    /// Pauses performance monitoring.
    ///
    /// Call this method to temporarily stop collecting performance data.
    /// Use `start()` to resume monitoring.
    public func pause() {
        isMonitoring = false
        performanceCalculator.pause()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
