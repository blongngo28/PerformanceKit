//
//  InfoRow.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import SwiftUI

/// Displays informational text with an icon
struct InfoRow: View {
    let icon: String
    let text: String
    let textColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(textColor)
                .font(.system(size: 12))
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 10))
                .foregroundColor(textColor)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}
