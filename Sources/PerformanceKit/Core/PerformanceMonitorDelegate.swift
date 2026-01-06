//
//  for.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import Foundation

/// Delegate protocol for receiving performance updates
public protocol PerformanceMonitorDelegate: AnyObject {
    /// Called when new performance metrics are available
    /// - Parameter performanceReport: The current performance metrics
    func performanceMonitor(didReport performanceReport: PerformanceReport)
}
