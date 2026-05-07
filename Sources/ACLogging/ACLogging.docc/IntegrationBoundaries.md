# Integration Boundaries

Keep logging calls stable in feature code while provider-specific behavior stays inside adapters.

## Code Reference

This article describes the unreleased ACLogging API planned for `0.1.0`. After a public release is tagged, use the DocC article generated from the matching Git tag for that package version.

## Core Usage

Create a `LogManager` with one or more services:

```swift
import ACLogging

let manager = LogManager(services: [analyticsService, diagnosticsService])
```

Model analytics events with `LoggableEvent`:

```swift
enum PaywallEvent: LoggableEvent {
    case viewStart(source: String)

    var eventName: String { "Paywall_View_Start" }

    var parameters: LogParameters? {
        switch self {
        case let .viewStart(source):
            return ["source": .string(source)]
        }
    }

    var logType: LogType { .analytic }
}
```

Then track the typed event:

```swift
manager.trackEvent(PaywallEvent.viewStart(source: "home"))
```

## Adapter Responsibilities

Adapters convert `LogValue` into provider-specific payloads. They also own delivery decisions such as batching, retry, persistence, and platform-specific fallbacks.

## Unsupported Behavior

`ACLogging` does not provide a remote analytics SDK, event queue, retry engine, persistence layer, or privacy policy. Those responsibilities belong to adapter packages and the consuming app.
