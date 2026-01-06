//
//  StyleButton.swift
//  PerformanceKit-Demo
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import SwiftUI

struct StyleButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    )
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
        }
    }
}
