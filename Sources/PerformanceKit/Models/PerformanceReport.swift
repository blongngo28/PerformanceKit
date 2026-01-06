//
//  PerformanceReport.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import Foundation

/// Represents memory usage in bytes
public typealias MemoryUsage = (used: UInt64, total: UInt64)

/// Complete performance metrics report
public typealias PerformanceReport = (
    cpuUsage: Double,
    fps: Int,
    memoryUsage: MemoryUsage
)
