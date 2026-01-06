//
//  OptionToggle.swift
//  PerformanceKit-Demo
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import SwiftUI

struct OptionToggle: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? Color.blue : Color.gray.opacity(0.5), lineWidth: 1)
                    )
            )
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
        }
    }
}
