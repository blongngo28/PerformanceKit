//
//  PerformanceKitModel.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import Foundation

/// Models used by PerformanceKit framework.
public enum PerformanceKitModel {
    /// Represents memory usage information.
    ///
    /// - used: The amount of memory currently used by the application, in bytes.
    /// - total: The total amount of physical memory available on the device, in bytes.
    public typealias MemoryUsage = (used: UInt64, total: UInt64)
    
    /// Represents a comprehensive performance report containing all monitored metrics.
    ///
    /// - cpuUsage: Current CPU usage as a percentage (0-100).
    /// - fps: Current frames per second (FPS) count.
    /// - memoryUsage: Current memory usage information.
    public typealias PerformanceReport = (cpuUsage: Double, fps: Int, memoryUsage: MemoryUsage)
}