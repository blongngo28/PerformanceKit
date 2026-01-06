//
//  ComplexAnimationView.swift
//  PerformanceKit-Demo
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import SwiftUI

struct ComplexAnimationView: View {
    let speed: Double
    let particleCount: Int
    
    @State private var phase1: Double = 0
    @State private var phase2: Double = 0
    @State private var phase3: Double = 0
    @State private var glowIntensity: Double = 1
    
    var body: some View {
        ZStack {
            // Background glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.blue.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                )
                .scaleEffect(glowIntensity)
                .blur(radius: 30)
            
            // Multiple rotating layers
            ForEach(0..<3) { layer in
                RotatingLayer(
                    layerIndex: layer,
                    particleCount: particleCount / 3,
                    phase: layer == 0 ? phase1 : (layer == 1 ? phase2 : phase3),
                    speed: speed
                )
            }
            
            // Central complex shape
            ZStack {
                ForEach(0..<8) { i in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 60, height: 20)
                        .rotationEffect(.degrees(Double(i) * 45 + phase1))
                        .offset(x: cos(phase1 + Double(i) * 0.5) * 80,
                                y: sin(phase1 + Double(i) * 0.5) * 80)
                        .shadow(color: .blue.opacity(0.7), radius: 10, x: 0, y: 0)
                }
            }
            .rotationEffect(.degrees(phase2))
        }
        .onAppear {
            withAnimation(
                .linear(duration: 6.0 / speed)
                .repeatForever(autoreverses: false)
            ) {
                phase1 = 360
            }
            
            withAnimation(
                .linear(duration: 8.0 / speed)
                .repeatForever(autoreverses: false)
            ) {
                phase2 = -360
            }
            
            withAnimation(
                .linear(duration: 10.0 / speed)
                .repeatForever(autoreverses: false)
            ) {
                phase3 = 360
            }
            
            withAnimation(
                .easeInOut(duration: 2.0 / speed)
                .repeatForever(autoreverses: true)
            ) {
                glowIntensity = 1.3
            }
        }
    }
}


#Preview {
    ComplexAnimationView(speed: 1, particleCount: 50)
}
