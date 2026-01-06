<div align="center">
  <h1>PerformanceKit</h1>
  <p><em>Real-time performance monitoring framework for SwiftUI apps</em></p>
</div>









<p align="center">
  <table align="center">
    <tr>
      <td align="center">
        <img width="280" height="610" alt="Preview" src="https://github.com/user-attachments/assets/9c9383de-115a-442e-9ca4-3561103d0bb1" />
      </td>
      <td align="center">
        <img width="280" height="610" alt="Demo Video" src="https://github.com/user-attachments/assets/42a6a757-0acd-4ec2-ab36-2f34a5853e42" />
      </td>
    </tr>
    <tr>
      <td align="center"><em>Screenshot</em></td>
      <td align="center"><em>Demo Video</em></td>
    </tr>
  </table>
</p>



A comprehensive performance monitoring framework for iOS, macOS, tvOS, and watchOS applications. PerformanceKit provides real-time monitoring of CPU usage, FPS, memory consumption, and system information through an easy-to-use overlay view.


> **Note**: This project was inspired by [GDPerformanceView-Swift](https://github.com/dani-gavrilov/GDPerformanceView-Swift) by Daniil Gavrilov. PerformanceKit builds upon those concepts with modern SwiftUI support, improved architecture, and enhanced customization options.


## Features

- **Real-time Performance Monitoring**: Track CPU usage, FPS, and memory consumption in real-time
- **Drag & Drop Overlay**: Interactive overlay that can be positioned anywhere on screen
- **Customizable Display**: Choose which metrics to display and customize the appearance
- **Cross-Platform Support**: Works on iOS, macOS, tvOS, and watchOS
- **SwiftUI & UIKit Support**: Seamless integration with both SwiftUI and UIKit
- **Programmatic Access**: Access performance data programmatically via delegate pattern
- **Lifecycle Aware**: Automatically pauses when app enters background

## Requirements

- iOS 14.0+
- macOS 11.0+
- tvOS 14.0+
- watchOS 7.0+
- Swift 5.7+
- Xcode 14.0+

## Installation

### Swift Package Manager

Add PerformanceKit to your project using Swift Package Manager:

1. In Xcode, select **File** → **Add Packages...**
2. Enter the package URL: `https://github.com/nazar-41/PerformanceKit.git`
3. Select the version rule you want to use
4. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nazar-41/PerformanceKit.git", from: "1.0.0")
]
```

## Quick Start

### SwiftUI

```swift
import SwiftUI
import PerformanceKit

struct ContentView: View {
    var body: some View {
        YourContentView()
            .performanceMonitor() // Adds the performance overlay
    }
}
```

### UIKit

```swift
import UIKit
import PerformanceKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start monitoring programmatically
        PerformanceMonitor.shared().delegate = self
        PerformanceMonitor.shared().start()
    }
}

extension ViewController: PerformanceMonitorDelegate {
    func performanceMonitor(didReport performanceReport: PerformanceReport) {
        print("CPU: \(performanceReport.cpuUsage)%")
        print("FPS: \(performanceReport.fps)")
    }
}
```

## Advanced Usage

### Customizing Display Options

```swift
.performanceMonitor(
    options: [.performance, .memory, .application],
    style: .light
)
```

### Custom Style

```swift
.performanceMonitor(
    style: .custom(
        backgroundColor: .blue.opacity(0.8),
        borderColor: .white,
        borderWidth: 2,
        cornerRadius: 16,
        textColor: .white
    )
)
```

### Programmatic Monitoring

```swift
// Access shared instance
let monitor = PerformanceMonitor.shared()

// Start monitoring
monitor.start()

// Access current report
if let report = monitor.currentReport {
    print("Current FPS: \(report.fps)")
}

// Set delegate for updates
monitor.delegate = self

// Pause monitoring
monitor.pause()
```

## API Reference

### PerformanceMonitor

The main class for managing performance monitoring.

#### Properties
- `currentReport: PerformanceReport?` - The latest performance report
- `delegate: PerformanceMonitorDelegate?` - Delegate for receiving updates

#### Methods
- `start()` - Begins performance monitoring
- `pause()` - Pauses performance monitoring
- `static shared() -> PerformanceMonitor` - Returns the shared instance

### PerformanceOverlayView

A SwiftUI view that displays performance metrics in a draggable overlay.

#### Initializer
```swift
init(
    monitor: PerformanceMonitor = .shared(),
    options: DisplayOptions = .default,
    style: PerformanceMonitor.Style = .dark
)
```

### View Extension

SwiftUI view modifier for easy integration:

```swift
func performanceMonitor(
    isEnabled: Bool = true,
    options: DisplayOptions = .default,
    style: PerformanceMonitor.Style = .dark,
    monitor: PerformanceMonitor = .shared()
) -> some View
```

## Display Options

PerformanceKit allows you to customize which metrics are displayed:

```swift
// Show only performance metrics
DisplayOptions.performance

// Show performance and memory
[.performance, .memory]

// Show everything
DisplayOptions.all

// Default options
DisplayOptions.default // [.performance, .memory]
```

Available options:
- `.performance` - CPU usage and FPS
- `.memory` - Memory usage
- `.application` - App version and build
- `.device` - Device model
- `.system` - OS name and version

## Visual Styles

Choose from predefined styles or create your own:

```swift
// Predefined styles
PerformanceMonitor.Style.dark
PerformanceMonitor.Style.light

// Custom style
PerformanceMonitor.Style.custom(
    backgroundColor: .blue.opacity(0.8),
    borderColor: .white,
    borderWidth: 2,
    cornerRadius: 16,
    textColor: .white
)
```

## Performance Report

The `PerformanceReport` type alias provides access to all monitored metrics:

```swift
typealias PerformanceReport = (
    cpuUsage: Double,        // CPU usage percentage (0-100)
    fps: Int,               // Frames per second
    memoryUsage: MemoryUsage // Memory usage information
)

typealias MemoryUsage = (
    used: UInt64,  // Used memory in bytes
    total: UInt64  // Total memory in bytes
)
```

## Best Practices

1. **Development Only**: Consider disabling PerformanceKit in production releases
2. **Conditional Enabling**: Use feature flags to enable/disable monitoring
3. **User Experience**: Position the overlay where it doesn't interfere with app interaction
4. **Battery Considerations**: Continuous monitoring may impact battery life during development


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues, questions, or feature requests, please [create an issue](https://github.com/nazar-41/PerformanceKit/issues) on GitHub.
