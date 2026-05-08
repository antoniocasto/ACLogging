# Integration Boundaries

Keep logging calls stable in feature code while provider-specific behavior stays inside adapters.

`ACLogging` is designed as an application boundary. App features describe what happened, adapters decide how that information reaches analytics, diagnostics, or platform logging destinations.

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

    var options: LogOptions {
        LogOptions(logType: .analytic, parameterPrivacy: .private)
    }
}
```

Then track the typed event:

```swift
manager.trackEvent(PaywallEvent.viewStart(source: "home"))
```

## Manager Responsibilities

`LogManager` fans out event calls to every configured `LogService`. It does not queue, retry, filter, persist, sample, or transform events before forwarding them.

Identity calls are forwarded only to services that conform to `LogIdentityService` or to identity services passed explicitly at initialization:

```swift
let manager = LogManager(
    services: [analyticsService, diagnosticsService],
    identityServices: [accountIdentityService]
)

manager.identify(
    LogSubject(
        id: "account-123",
        kind: "account",
        properties: ["plan": .string("pro")]
    )
)
```

## Adapter Responsibilities

Adapters convert `LogValue` into provider-specific payloads. They also own delivery decisions such as batching, retry, persistence, upload timing, sampling, platform-specific fallbacks, and SDK conversion.

Adapters should treat `LogOptions.parameterPrivacy` as an instruction from the app's privacy review. For example, `ACLoggingOSLog` keeps event names public and applies the requested privacy level to rendered parameters.

## App Responsibilities

The consuming app owns the event taxonomy and should keep it stable over time:

- Use predictable event names such as `Paywall_View_Start`.
- Keep parameter keys consistent across related events.
- Avoid sending sensitive values unless the app has reviewed both the parameter and the destination.
- Choose adapters that match the app's analytics, diagnostics, and privacy requirements.

## Unsupported Behavior

`ACLogging` does not provide a remote analytics SDK, event queue, retry engine, persistence layer, upload scheduler, consent manager, or privacy policy. Those responsibilities belong to adapter packages and the consuming app.
