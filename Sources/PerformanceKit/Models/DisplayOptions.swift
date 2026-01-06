//
//  DisplayOptions.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import Foundation

/// Display options for configuring what information is shown in the performance overlay.
///
/// Use these options to customize which metrics are displayed in the overlay view.
/// Combine options using the OptionSet syntax to show multiple metrics.
///
/// ## Example
/// ```swift
/// // Show only performance metrics
/// let options: DisplayOptions = .performance
///
/// // Show performance and memory metrics
/// let options: DisplayOptions = [.performance, .memory]
///
/// // Show all available metrics
/// let options: DisplayOptions = .all
/// ```
public struct DisplayOptions: OptionSet, Sendable {
    /// The raw value of the option set.
    public let rawValue: Int
    
    /// Display CPU usage and FPS metrics.
    ///
    /// When included, the overlay will show:
    /// - CPU usage percentage
    /// - Frames per second (FPS)
    public static let performance = DisplayOptions(rawValue: 1 << 0)
    
    /// Display memory usage metrics.
    ///
    /// When included, the overlay will show:
    /// - Current memory usage in MB
    public static let memory = DisplayOptions(rawValue: 1 << 1)
    
    /// Display application version information.
    ///
    /// When included, the overlay will show:
    /// - Application version number
    /// - Build number
    public static let application = DisplayOptions(rawValue: 1 << 2)
    
    /// Display device model information.
    ///
    /// When included, the overlay will show:
    /// - Device model identifier
    public static let device = DisplayOptions(rawValue: 1 << 3)
    
    /// Display system version information.
    ///
    /// When included, the overlay will show:
    /// - Operating system name
    /// - Operating system version
    public static let system = DisplayOptions(rawValue: 1 << 4)
    
    /// Default display options.
    ///
    /// Includes performance metrics (CPU & FPS) and memory usage.
    public static let `default`: DisplayOptions = [.performance, .memory]
    
    /// All available display options.
    ///
    /// Includes all metrics: performance, memory, application, device, and system information.
    public static let all: DisplayOptions = [.performance, .memory, .application, .device, .system]
    
    /// Creates a new DisplayOptions instance with the given raw value.
    ///
    /// - Parameter rawValue: The raw integer value for the option set.
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
