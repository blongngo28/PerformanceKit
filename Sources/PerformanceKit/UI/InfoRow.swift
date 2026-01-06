//
//  InfoRow.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import SwiftUI

/// A row component for displaying informational text.
///
/// Used internally by `PerformanceOverlayView` to display
/// system and application information.
struct InfoRow: View {
    /// The SF Symbol name for the information icon.
    let icon: String
    
    /// The informational text to display.
    let text: String
    
    /// The text color for the row.
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