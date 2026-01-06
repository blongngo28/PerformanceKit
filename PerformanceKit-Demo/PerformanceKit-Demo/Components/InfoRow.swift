//
//  InfoRow.swift
//  PerformanceKit-Demo
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
        }
    }
}
