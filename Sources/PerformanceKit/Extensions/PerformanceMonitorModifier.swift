//
//  PerformanceMonitorModifier.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import SwiftUI

/// A view modifier that adds performance monitoring capabilities to any view.
///
/// Use this modifier to easily add the performance overlay to any SwiftUI view.
/// The modifier provides a convenient way to enable performance monitoring
/// without manually managing the overlay's lifecycle.
public struct PerformanceMonitorModifier: ViewModifier {
    /// Whether the performance monitor is enabled.
    let isEnabled: Bool
    
    /// The display options for the performance overlay.
    let options: DisplayOptions
    
    /// The visual style of the performance overlay.
    let style: PerformanceMonitor.Style
    
    /// The performance monitor instance to use.
    let monitor: PerformanceMonitor
    
    /// Creates a new performance monitor modifier.
    ///
    /// - Parameters:
    ///   - isEnabled: Whether the performance monitor is enabled.
    ///   - options: The display options for the performance overlay.
    ///   - style: The visual style of the performance overlay.
    ///   - monitor: The performance monitor instance to use.
    public init(
        isEnabled: Bool = true,
        options: DisplayOptions = .default,
        style: PerformanceMonitor.Style = .dark,
        monitor: PerformanceMonitor = .shared()
    ) {
        self.isEnabled = isEnabled
        self.options = options
        self.style = style
        self.monitor = monitor
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if isEnabled {
                PerformanceOverlayView(
                    monitor: monitor,
                    options: options,
                    style: style
                )
            }
        }
    }
}

public extension View {
    /// Adds a performance monitoring overlay to the view.
    ///
    /// This modifier adds a draggable, resizable performance overlay that
    /// displays real-time metrics about your application's performance.
    ///
    /// - Parameters:
    ///   - isEnabled: Whether the performance monitor is enabled. Defaults to `true`.
    ///   - options: The display options determining which metrics are shown.
    ///              Defaults to `.default` (CPU, FPS, and memory).
    ///   - style: The visual style of the performance overlay.
    ///            Defaults to `.dark`.
    ///   - monitor: The performance monitor instance to use.
    ///              Defaults to the shared instance.
    /// - Returns: A view modified to include the performance overlay.
    ///
    /// ## Usage Examples
    ///
    /// ### Basic Usage
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         YourContentView()
    ///             .performanceMonitor()
    ///     }
    /// }
    /// ```
    ///
    /// ### Customized Overlay
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         YourContentView()
    ///             .performanceMonitor(
    ///                 options: [.performance, .application],
    ///                 style: .light
    ///             )
    ///     }
    /// }
    /// ```
    ///
    /// ### Conditional Monitoring
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showMonitor = false
    ///
    ///     var body: some View {
    ///         YourContentView()
    ///             .performanceMonitor(isEnabled: showMonitor)
    ///             .onTapGesture(count: 3) {
    ///                 showMonitor.toggle()
    ///             }
    ///     }
    /// }
    /// ```
    func performanceMonitor(
        isEnabled: Bool = true,
        options: DisplayOptions = .default,
        style: PerformanceMonitor.Style = .dark,
        monitor: PerformanceMonitor = .shared()
    ) -> some View {
        self.modifier(PerformanceMonitorModifier(
            isEnabled: isEnabled,
            options: options,
            style: style,
            monitor: monitor
        ))
    }
}