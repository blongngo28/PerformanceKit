//
//  ContentView.swift
//  PerformanceKit-Demo
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import SwiftUI
import PerformanceKit

struct ContentView: View {
    @State private var animationSpeed: Double = 1.0
    @State private var particleCount: Int = 50
    @State private var isComplexAnimation: Bool = false
    @State private var isMonitoringEnabled: Bool = true
    @State private var selectedOptions: DisplayOptions = .all
    @State private var selectedStyle: PerformanceMonitor.Style = .dark
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.05, green: 0.05, blue: 0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "speedometer")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("PerformanceKit Demo")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Real-time performance monitoring for SwiftUI apps")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // Controls Card
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Controls")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        // Performance Monitor Toggle
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(.blue)
                            
                            Toggle("Performance Monitor", isOn: $isMonitoringEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                                .foregroundColor(.white)
                        }
                        
                        // Display Options
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Display Options")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    OptionToggle(
                                        title: "CPU & FPS",
                                        icon: "cpu",
                                        isSelected: selectedOptions.contains(.performance)
                                    ) {
                                        selectedOptions.formSymmetricDifference(.performance)
                                    }
                                    
                                    OptionToggle(
                                        title: "Memory",
                                        icon: "memorychip",
                                        isSelected: selectedOptions.contains(.memory)
                                    ) {
                                        selectedOptions.formSymmetricDifference(.memory)
                                    }
                                    
                                    OptionToggle(
                                        title: "App Info",
                                        icon: "app",
                                        isSelected: selectedOptions.contains(.application)
                                    ) {
                                        selectedOptions.formSymmetricDifference(.application)
                                    }
                                    
                                    OptionToggle(
                                        title: "Device",
                                        icon: "iphone",
                                        isSelected: selectedOptions.contains(.device)
                                    ) {
                                        selectedOptions.formSymmetricDifference(.device)
                                    }
                                    
                                    OptionToggle(
                                        title: "System",
                                        icon: "gear",
                                        isSelected: selectedOptions.contains(.system)
                                    ) {
                                        selectedOptions.formSymmetricDifference(.system)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                        // Style Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Style")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack(spacing: 15) {
                                StyleButton(
                                    title: "Dark",
                                    icon: "moon.fill",
                                    isSelected: selectedStyle == .dark
                                ) {
                                    selectedStyle = .dark
                                }
                                
                                StyleButton(
                                    title: "Light",
                                    icon: "sun.max.fill",
                                    isSelected: selectedStyle == .light
                                ) {
                                    selectedStyle = .light
                                }
                                
                                StyleButton(
                                    title: "Custom",
                                    icon: "paintbrush.fill",
                                    isSelected: {
                                        if case .custom = selectedStyle { return true }
                                        return false
                                    }()
                                ) {
                                    selectedStyle = .custom(
                                        backgroundColor: Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.9),
                                        borderColor: .blue,
                                        borderWidth: 2,
                                        cornerRadius: 16,
                                        textColor: .white
                                    )
                                }
                            }
                        }
                        
                        // Animation Controls
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Animation Stress Test")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                            
                            VStack(spacing: 15) {
                                HStack {
                                    Image(systemName: "speedometer")
                                        .foregroundColor(.green)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Animation Speed: \(animationSpeed, specifier: "%.1f")x")
                                            .foregroundColor(.white)
                                        Slider(value: $animationSpeed, in: 0.1...3.0, step: 0.1)
                                            .tint(.green)
                                    }
                                }
                                
                                HStack {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.purple)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Particle Count: \(particleCount)")
                                            .foregroundColor(.white)
                                        Slider(value: .init(
                                            get: { Double(particleCount) },
                                            set: { particleCount = Int($0) }
                                        ), in: 10...200, step: 10)
                                        .tint(.purple)
                                    }
                                }
                                
                                Toggle("Complex Animation", isOn: $isComplexAnimation)
                                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal)
                    
                    // Animation Area
                    ZStack {
                        // Background for animation area
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.1, green: 0.1, blue: 0.2).opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                            )
                        
                        VStack {
                            Text("Animation Test Area")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            
                            Text("Adjust controls to stress test performance")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.bottom, 20)
                            
                            // Main animated element
                            ZStack {
                                if isComplexAnimation {
                                    ComplexAnimationView(speed: animationSpeed, particleCount: particleCount)
                                } else {
                                    SimpleAnimationView(speed: animationSpeed, particleCount: particleCount)
                                }
                            }
                            .frame(height: 300)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Info Card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                            
                            Text("About PerformanceKit")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            InfoRow(icon: "cursorarrow.click", text: "Drag the monitor overlay to reposition")
                            InfoRow(icon: "chevron.up.chevron.down", text: "Tap the chevron to collapse/expand")
                            InfoRow(icon: "paintpalette.fill", text: "Customize colors, borders, and corners")
                            InfoRow(icon: "chart.bar.fill", text: "Monitor CPU, FPS, memory in real-time")
                            InfoRow(icon: "iphone.gen3", text: "Supports iOS, macOS, tvOS, watchOS")
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
        // Apply PerformanceKit overlay
        .performanceMonitor(
            isEnabled: isMonitoringEnabled,
            options: selectedOptions,
            style: selectedStyle
        )
    }
}

#Preview {
    ContentView()
}
