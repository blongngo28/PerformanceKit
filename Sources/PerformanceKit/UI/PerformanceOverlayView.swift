//
//  PerformanceOverlayView.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import SwiftUI

/// A draggable overlay view that displays real-time performance metrics.
///
/// `PerformanceOverlayView` provides an intuitive, floating overlay that shows
/// real-time performance information. It can be dragged around the screen and
/// collapsed/expanded as needed.
///
/// ## Features
/// - Draggable positioning
/// - Expandable/collapsible interface
/// - Real-time performance updates
/// - Customizable appearance
/// - Multiple display options
///
/// ## Usage Example
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         ZStack {
///             // Your main content
///             YourContentView()
///
///             // Performance overlay
///             PerformanceOverlayView(
///                 options: [.performance, .memory],
///                 style: .dark
///             )
///         }
///     }
/// }
/// ```
public struct PerformanceOverlayView: View {
    @StateObject private var monitor: PerformanceMonitor
    @State private var position: CGPoint = CGPoint(x: 100, y: 100)
    @State private var isDragging = false
    @State private var isExpanded = true
    
    /// The display options determining which metrics are shown.
    ///
    /// Use this property to customize which performance metrics are displayed
    /// in the overlay. Combine multiple options using array syntax.
    public var options: DisplayOptions
    
    /// The visual style of the overlay.
    ///
    /// Choose from predefined styles (.dark, .light) or create a fully
    /// custom style with the `.custom` case.
    public var style: PerformanceMonitor.Style
    
    /// Creates a new performance overlay view.
    ///
    /// - Parameters:
    ///   - monitor: The performance monitor instance to use. Defaults to the shared instance.
    ///   - options: Display options determining which metrics are shown. Defaults to `.default`.
    ///   - style: The visual style of the overlay. Defaults to `.dark`.
    ///
    /// ## Example
    /// ```swift
    /// // Basic overlay with default settings
    /// PerformanceOverlayView()
    ///
    /// // Customized overlay
    /// PerformanceOverlayView(
    ///     options: [.performance, .memory, .application],
    ///     style: .light
    /// )
    ///
    /// // Fully customized overlay
    /// PerformanceOverlayView(
    ///     style: .custom(
    ///         backgroundColor: .blue.opacity(0.8),
    ///         borderColor: .white,
    ///         borderWidth: 2,
    ///         cornerRadius: 16,
    ///         textColor: .white
    ///     )
    /// )
    /// ```
    public init(
        monitor: PerformanceMonitor = .shared(),
        options: DisplayOptions = .default,
        style: PerformanceMonitor.Style = .dark
    ) {
        _monitor = StateObject(wrappedValue: monitor)
        self.options = options
        self.style = style
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header with drag handle and expand/collapse
            HStack {
                Image(systemName: "speedometer")
                    .foregroundColor(headerTextColor)
                    .font(.system(size: 12))
                
                Text("Performance")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(headerTextColor)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(headerTextColor)
                        .font(.system(size: 10))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(headerBackgroundColor)
            
            // Metrics content (visible when expanded)
            if isExpanded, let report = monitor.currentReport {
                VStack(spacing: 8) {
                    // Performance (CPU & FPS)
                    if options.contains(.performance) {
                        MetricRow(
                            icon: "gauge",
                            label: "FPS",
                            value: "\(report.fps)",
                            color: fpsColor(report.fps),
                            textColor: metricTextColor
                        )
                        
                        Divider()
                            .background(dividerColor)
                        
                        MetricRow(
                            icon: "cpu",
                            label: "CPU",
                            value: String(format: "%.1f%%", report.cpuUsage),
                            color: usageColor(report.cpuUsage),
                            textColor: metricTextColor
                        )
                    }
                    
                    // Memory
                    if options.contains(.memory) {
                        Divider()
                            .background(dividerColor)
                        
                        let usedMB = Double(report.memoryUsage.used) / 1024 / 1024
                        MetricRow(
                            icon: "memorychip",
                            label: "RAM",
                            value: String(format: "%.1f MB", usedMB),
                            color: memoryColor(usedMB),
                            textColor: metricTextColor
                        )
                    }
                    
                    // Application info
                    if options.contains(.application) {
                        Divider()
                            .background(dividerColor)
                        
                        InfoRow(
                            icon: "app",
                            text: applicationVersion(),
                            textColor: metricTextColor
                        )
                    }
                    
                    // Device info
                    if options.contains(.device) {
                        Divider()
                            .background(dividerColor)
                        
                        InfoRow(
                            icon: "iphone",
                            text: deviceModel(),
                            textColor: metricTextColor
                        )
                    }
                    
                    // System info
                    if options.contains(.system) {
                        Divider()
                            .background(dividerColor)
                        
                        InfoRow(
                            icon: "gear",
                            text: systemVersion(),
                            textColor: metricTextColor
                        )
                    }
                }
                .padding(.vertical, 8)
                .background(contentBackgroundColor)
            }
        }
        .frame(width: 180)
        .background(contentBackgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        .position(position)
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    position = value.location
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
        .onAppear {
            monitor.start()
        }
        .onDisappear {
            monitor.pause()
        }
    }
    
    // MARK: - Style Properties
    
    private var headerBackgroundColor: Color {
        switch style {
        case .dark:
            return Color.black.opacity(0.9)
        case .light:
            return Color.white.opacity(0.9)
        case .custom(let bg, _, _, _, _):
            return bg
        }
    }
    
    private var contentBackgroundColor: Color {
        switch style {
        case .dark:
            return Color.black.opacity(0.85)
        case .light:
            return Color.white.opacity(0.85)
        case .custom(let bg, _, _, _, _):
            return bg
        }
    }
    
    private var headerTextColor: Color {
        switch style {
        case .dark:
            return .white
        case .light:
            return .black
        case .custom(_, _, _, _, let text):
            return text
        }
    }
    
    private var metricTextColor: Color {
        switch style {
        case .dark:
            return .white.opacity(0.7)
        case .light:
            return .black.opacity(0.7)
        case .custom(_, _, _, _, let text):
            return text.opacity(0.7)
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .dark:
            return .white
        case .light:
            return .black
        case .custom(_, let border, _, _, _):
            return border
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .dark, .light:
            return 1
        case .custom(_, _, let width, _, _):
            return width
        }
    }
    
    private var cornerRadius: CGFloat {
        switch style {
        case .dark, .light:
            return 12
        case .custom(_, _, _, let radius, _):
            return radius
        }
    }
    
    private var dividerColor: Color {
        headerTextColor.opacity(0.2)
    }
    
    // MARK: - Helper Methods
    
    private func fpsColor(_ fps: Int) -> Color {
        switch fps {
        case 50...Int.max:
            return .green
        case 30..<50:
            return .yellow
        default:
            return .red
        }
    }
    
    private func usageColor(_ usage: Double) -> Color {
        switch usage {
        case 0..<50:
            return .green
        case 50..<80:
            return .yellow
        default:
            return .red
        }
    }
    
    private func memoryColor(_ usedMB: Double) -> Color {
        switch usedMB {
        case 0..<200:
            return .green
        case 200..<400:
            return .yellow
        default:
            return .red
        }
    }
    
    private func applicationVersion() -> String {
        var version = "Unknown"
        var build = "Unknown"
        if let infoDictionary = Bundle.main.infoDictionary {
            if let v = infoDictionary["CFBundleShortVersionString"] as? String {
                version = v
            }
            if let b = infoDictionary["CFBundleVersion"] as? String {
                build = b
            }
        }
        return "v\(version) (\(build))"
    }
    
    private func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return model
    }
    
    private func systemVersion() -> String {
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        return "\(systemName) \(systemVersion)"
    }
}
