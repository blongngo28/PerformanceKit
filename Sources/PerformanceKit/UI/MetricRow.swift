//
//  MetricRow.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import SwiftUI

/// A row component for displaying a single performance metric.
///
/// Used internally by `PerformanceOverlayView` to display individual
/// performance metrics with consistent styling.
struct MetricRow: View {
    /// The SF Symbol name for the metric icon.
    let icon: String
    
    /// The label describing the metric.
    let label: String
    
    /// The formatted value of the metric.
    let value: String
    
    /// The color indicating the metric's status (good/warning/bad).
    let color: Color
    
    /// The text color for the row.
    let textColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 12))
                .frame(width: 20)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(textColor)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundColor(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}