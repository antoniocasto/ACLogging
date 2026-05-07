# OSLog Adapter Examples

Use `ACLoggingOSLog` when you want ACLogging events to appear in Apple's unified logging system.

## Code Reference

This article describes the ACLogging API released in `1.0.0`. Published DocC should be generated from the matching Git tag for the package version being documented.

## Basic Setup

Create an `OSLogService` and pass it to `LogManager`:

```swift
import ACLogging
import ACLoggingOSLog

let manager = LogManager(
    services: [
        OSLogService(
            subsystem: "com.example.app",
            category: "Analytics",
            shouldPrintParameters: true
        )
    ]
)
```

When `subsystem` is `nil`, `OSLogService` uses `Bundle.main.bundleIdentifier` and falls back to `ACLogging`.

## Logging Events

General events and screen events use the same OSLog formatting path:

```swift
manager.trackEvent(
    eventName: "Onboarding_Skip",
    parameters: ["step": .string("notifications")],
    logType: .analytic
)

manager.trackScreenEvent(
    AnyLoggableEvent(
        eventName: "Home_appear",
        parameters: nil,
        logType: .analytic
    )
)
```

## Parameter Privacy

`OSLogService` currently writes the rendered message with public privacy. Disable parameter printing if values may contain sensitive data:

```swift
let diagnosticsOnlyService = OSLogService(
    subsystem: "com.example.app",
    category: "Diagnostics",
    shouldPrintParameters: false
)
```

With parameter printing disabled, the log message contains only the event name.
