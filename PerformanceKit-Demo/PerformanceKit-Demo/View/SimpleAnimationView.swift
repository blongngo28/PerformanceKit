//
//  SimpleAnimationView.swift
//  PerformanceKit-Demo
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import SwiftUI

struct SimpleAnimationView: View {
    let speed: Double
    let particleCount: Int
    
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var hueRotation: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<particleCount, id: \.self) { index in
                let offset = Double(index) * (360.0 / Double(particleCount))
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hue: (Double(index) / Double(particleCount)), saturation: 1, brightness: 1),
                                Color(hue: (Double(index) / Double(particleCount)), saturation: 0.5, brightness: 0.5)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .frame(width: 20, height: 20)
                    .offset(x: cos(rotation + offset) * 100,
                            y: sin(rotation + offset) * 100)
                    .scaleEffect(scale)
                    .blur(radius: 2)
                    .opacity(0.8)
            }
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 4)
                )
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .shadow(color: .blue.opacity(0.5), radius: 20, x: 0, y: 0)
        }
        .hueRotation(.degrees(hueRotation))
        .onAppear {
            withAnimation(
                .easeInOut(duration: 4.0 / speed)
                .repeatForever(autoreverses: true)
            ) {
                scale = 1.2
            }
            
            withAnimation(
                .linear(duration: 8.0 / speed)
                .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
            
            withAnimation(
                .linear(duration: 12.0 / speed)
                .repeatForever(autoreverses: false)
            ) {
                hueRotation = 360
            }
        }
        .onChange(of: speed) {_, newSpeed in
            // Update animations with new speed
            withAnimation(
                .easeInOut(duration: 4.0 / newSpeed)
                .repeatForever(autoreverses: true)
            ) {
                scale = 1.2
            }
            
            withAnimation(
                .linear(duration: 8.0 / newSpeed)
                .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}


#Preview {
    SimpleAnimationView(speed: 1, particleCount: 50)
}
