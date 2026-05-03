# Adapter Guide

## Core

`ACLogging` defines the provider-neutral logging surface:

- `LogManager` forwards calls to one or more services.
- `LogService` is implemented by adapters.
- `LoggableEvent` describes typed events.
- `LogParameters` and `LogValue` keep parameters explicit and deterministic.

The core target should not import provider SDKs, `OSLog`, SwiftUI, Firebase, or Mixpanel.

## OSLog

`ACLoggingOSLog` implements `OSLogService`, which writes events through Apple's unified logging system.

```swift
import ACLogging
import ACLoggingOSLog

let manager = LogManager(
    services: [
        OSLogService(subsystem: "com.example.app", category: "Analytics")
    ]
)
```

Log type mapping:

- `.info` maps to `OSLogType.info`
- `.analytic` maps to `OSLogType.default`
- `.warning` maps to `OSLogType.error`
- `.severe` maps to `OSLogType.fault`

Parameters are sorted by key before formatting so tests and console output are stable.

## SwiftUI

`ACLoggingSwiftUI` keeps the SwiftUI dependency isolated from the core.

```swift
import ACLoggingSwiftUI

PaywallView()
    .logManager(manager)
    .screenLogging(name: "Paywall")
```

The modifier tracks:

- `Paywall_appear`
- `Paywall_disappear`

`LogManager` is injected through a custom environment key and does not need to conform to Observation APIs.

## Future Adapters

Firebase and Mixpanel adapters should be separate products with their own dependencies. They should convert `LogValue` into provider-specific parameter types at the boundary.
