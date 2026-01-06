//
//  MetricRow.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import SwiftUI

/// Displays a single performance metric with icon, label, and value
struct MetricRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
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