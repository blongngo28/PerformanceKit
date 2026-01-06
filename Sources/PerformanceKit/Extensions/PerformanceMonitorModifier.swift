//
//  PerformanceMonitorModifier.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import SwiftUI

/// View modifier for adding performance monitoring overlay
public struct PerformanceMonitorModifier: ViewModifier {
    let isEnabled: Bool
    let options: PerformanceMonitor.DisplayOptions
    let style: PerformanceMonitor.Style
    let monitor: PerformanceMonitor
    
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
    /// Adds a performance monitoring overlay to the view
    /// - Parameters:
    ///   - isEnabled: Whether the monitor is visible
    ///   - options: What information to display
    ///   - style: Visual style of the overlay
    ///   - monitor: Performance monitor instance (defaults to shared)
    /// - Returns: View with performance monitor overlay
    func performanceMonitor(
        isEnabled: Bool = true,
        options: PerformanceMonitor.DisplayOptions = .default,
        style: PerformanceMonitor.Style = .dark,
        monitor: PerformanceMonitor = .shared
    ) -> some View {
        self.modifier(
            PerformanceMonitorModifier(
                isEnabled: isEnabled,
                options: options,
                style: style,
                monitor: monitor
            )
        )
    }
}
