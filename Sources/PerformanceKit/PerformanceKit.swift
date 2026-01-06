//
//  PerformanceKit.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import SwiftUI

/// PerformanceKit - A comprehensive performance monitoring framework for iOS, macOS, tvOS, and watchOS.
///
/// PerformanceKit provides real-time monitoring of CPU usage, FPS, memory consumption, and system information
/// through an easy-to-use overlay view. It's designed to help developers optimize their applications
/// by providing immediate feedback on performance metrics during development and testing.
///
/// ## Features
/// - Real-time CPU usage monitoring
/// - FPS (Frames Per Second) tracking
/// - Memory usage tracking
/// - System and application information
/// - Customizable overlay view
/// - Programmatic access to performance data
/// - Support for iOS, macOS, tvOS, and watchOS
///
/// ## Quick Start
/// ```swift
/// import SwiftUI
/// import PerformanceKit
///
/// struct ContentView: View {
///     var body: some View {
///         YourContentView()
///             .performanceMonitor()
///     }
/// }
/// ```
///
/// ## Advanced Usage
/// ```swift
/// PerformanceMonitor.shared().start()
/// ```
///
/// ## Platform Support
/// - iOS 14.0+
/// - macOS 11.0+
/// - tvOS 14.0+
/// - watchOS 7.0+
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct PerformanceKit {
    /// Initializes PerformanceKit framework.
    ///
    /// This initializer sets up the performance monitoring framework. It's recommended to initialize
    /// PerformanceKit early in your application lifecycle, typically in your AppDelegate or
    /// @main App struct.
    public init() {}
}

// MARK: - Type Aliases

/// Type alias for a tuple containing performance metrics report.
///
/// Contains CPU usage, FPS, and memory usage information.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias PerformanceReport = PerformanceKitModel.PerformanceReport

/// Type alias for memory usage information.
///
/// Contains used and total memory in bytes.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public typealias MemoryUsage = PerformanceKitModel.MemoryUsage
