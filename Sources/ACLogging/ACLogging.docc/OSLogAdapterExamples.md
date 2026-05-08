# OSLog Adapter Examples

Use `ACLoggingOSLog` when you want ACLogging events to appear in Apple's unified logging system.

## Basic Setup

Create an `OSLogService` and pass it to `LogManager`. Choose a stable subsystem and category so Console queries remain predictable:

```swift
import ACLogging
import ACLoggingOSLog

let manager = LogManager(
    services: [
        OSLogService(
            subsystem: "com.example.app",
            category: "Analytics"
        )
    ]
)
```

When `subsystem` is `nil`, `OSLogService` uses `Bundle.main.bundleIdentifier` and falls back to `ACLogging`.

## Log Type Mapping

`OSLogService` maps ACLogging categories to unified logging levels:

- `.info` maps to `OSLogType.info`.
- `.analytic` maps to `OSLogType.default`.
- `.warning` maps to `OSLogType.error`.
- `.severe` maps to `OSLogType.fault`.

## Logging Events

General events and screen events use the same OSLog formatting path:

```swift
manager.trackEvent(
    eventName: "Onboarding_Skip",
    parameters: ["step": .string("notifications")],
    options: LogOptions(logType: .analytic, parameterPrivacy: .private)
)

manager.trackScreenEvent(
    AnyLoggableEvent(
        eventName: "Home_appear",
        parameters: nil
    )
)
```

## Parameter Privacy

`OSLogService` keeps the event name public and applies each event's `LogOptions.parameterPrivacy` to rendered parameters. Parameters are private by default:

```swift
manager.trackEvent(
    eventName: "Diagnostics_Config_Loaded",
    parameters: ["source": .string("local")],
    options: LogOptions(logType: .info)
)
```

Hide parameters when values should not be written to unified logging:

```swift
manager.trackEvent(
    eventName: "Account_Delete_Fail",
    parameters: ["reason": .string("permissionDenied")],
    options: LogOptions(logType: .warning, parameterPrivacy: .hidden)
)
```

Use public parameters only for values that have already passed the app's privacy review:

```swift
manager.trackEvent(
    eventName: "Debug_Menu_Opened",
    parameters: ["source": .string("simulator")],
    options: LogOptions(logType: .info, parameterPrivacy: .public)
)
```

## Identity Events

`OSLogService` also conforms to `LogIdentityService`. Identity updates are logged as `IdentifySubject` and include the subject `id`, `kind`, and custom properties. Clearing identity logs a `ClearIdentity` event:

```swift
manager.identify(
    LogSubject(
        id: "account-123",
        kind: "account",
        properties: ["plan": .string("pro")]
    )
)

manager.clearIdentity()
```

Use identity logging only when unified logging is an appropriate destination for those subject attributes.
