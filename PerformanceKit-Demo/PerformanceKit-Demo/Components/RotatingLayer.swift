//
//  RotatingLayer.swift
//  PerformanceKit-Demo
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import SwiftUI

struct RotatingLayer: View {
    let layerIndex: Int
    let particleCount: Int
    let phase: Double
    let speed: Double
    
    var body: some View {
        ForEach(0..<particleCount, id: \.self) { i in
            let angle = Double(i) * (360.0 / Double(particleCount))
            let radius = 80.0 + Double(layerIndex) * 40
            
            Circle()
                .fill(
                    Color(
                        hue: (Double(i) / Double(particleCount) + Double(layerIndex) * 0.3).truncatingRemainder(dividingBy: 1.0),
                        saturation: 0.8,
                        brightness: 0.9
                    )
                )
                .frame(width: 12 + CGFloat(layerIndex) * 4, height: 12 + CGFloat(layerIndex) * 4)
                .offset(
                    x: cos(angle * .pi / 180 + phase) * radius,
                    y: sin(angle * .pi / 180 + phase) * radius
                )
                .blur(radius: 1)
        }
    }
}
