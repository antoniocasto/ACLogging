# ACLogging

ACLogging is a small Swift Package for provider-agnostic application logging on iOS and macOS.

The package is split into focused products:

- `ACLogging`: dependency-free core types, including `LogManager`, `LogService`, `LoggableEvent`, `LogParameters`, and `LogValue`.
- `ACLoggingOSLog`: Apple `OSLog` adapter for local development, Console, and unified logging.
- `ACLoggingSwiftUI`: SwiftUI screen lifecycle tracking helpers.
- `ACLoggingTestSupport`: testing utilities such as `MockLogService`.

Firebase and Mixpanel are intentionally separate future adapters. They should live outside the core so their SDK dependencies never leak into `ACLogging`.

## Installation

Add the package with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/antoniocasto/ACLogging.git", from: "0.1.0")
]
```

Then add the products you need to each target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        "ACLogging",
        "ACLoggingOSLog",
        "ACLoggingSwiftUI"
    ]
)
```

## Versioning

ACLogging uses Semantic Versioning for package releases. Documentation, changelog entries, Git tags, and GitHub releases use plain versions such as `0.1.0`, without a leading `v`.

See [Versioning and Releases](docs/Versioning.md) for the release flow, changelog rules, tag format, and future `ROADMAP.md` conventions.

## Setup

```swift
import ACLogging
import ACLoggingOSLog

let logManager = LogManager(
    services: [
        OSLogService(
            subsystem: "com.example.app",
            category: "App",
            shouldPrintParameters: true
        )
    ]
)
```

`OSLogService` accepts an explicit subsystem and falls back to `Bundle.main.bundleIdentifier ?? "ACLogging"` when one is not provided.

## Typed Events

Model events as typed values and expose the `LoggableEvent` fields:

```swift
import ACLogging

enum PaywallEvent: LoggableEvent {
    case viewStart(source: String)
    case purchaseSuccess(productId: String, amount: Double)
    case purchaseFail(reason: String)

    var eventName: String {
        switch self {
        case .viewStart:
            return "Paywall_View_Start"
        case .purchaseSuccess:
            return "Paywall_Purchase_Success"
        case .purchaseFail:
            return "Paywall_Purchase_Fail"
        }
    }

    var parameters: LogParameters? {
        switch self {
        case let .viewStart(source):
            return ["source": .string(source)]
        case let .purchaseSuccess(productId, amount):
            return [
                "productId": .string(productId),
                "amount": .double(amount)
            ]
        case let .purchaseFail(reason):
            return ["reason": .string(reason)]
        }
    }

    var logType: LogType {
        switch self {
        case .viewStart:
            return .info
        case .purchaseSuccess:
            return .analytic
        case .purchaseFail:
            return .warning
        }
    }
}
```

Track events through the manager:

```swift
logManager.trackEvent(PaywallEvent.viewStart(source: "home"))
logManager.trackEvent(
    eventName: "Settings_Save_Success",
    parameters: ["section": .string("notifications")],
    logType: .analytic
)
```

The public API uses `LogParameters` and `LogValue`, not `[String: Any]`. This keeps adapter implementations deterministic and avoids runtime type casting.

## User Properties

```swift
logManager.identifyUser(
    userId: "user-123",
    name: "Antonio",
    email: "antonio@example.com"
)

logManager.addUserProperties(
    [
        "plan": .string("pro"),
        "isBetaTester": .bool(true)
    ],
    isHighPriority: true
)
```

## SwiftUI Screen Tracking

Import `ACLoggingSwiftUI`, inject a `LogManager`, and attach `screenLogging(name:)` to views:

```swift
import ACLogging
import ACLoggingSwiftUI
import SwiftUI

struct ContentView: View {
    let logManager: LogManager

    var body: some View {
        PaywallView()
            .logManager(logManager)
    }
}

struct PaywallView: View {
    var body: some View {
        Text("Paywall")
            .screenLogging(name: "Paywall")
    }
}
```

This tracks `Paywall_appear` on `onAppear` and `Paywall_disappear` on `onDisappear`. `LogManager` does not need to be `@Observable`.

## Event Naming

Use this convention:

```text
<Feature>_<Action>_<State>
```

Examples:

- `Paywall_View_Start`
- `Paywall_View_Success`
- `Paywall_View_Fail`
- `Settings_Save_Success`
- `Onboarding_Skip`

For async flows, prefer `Start`, `Success`, and `Fail` states so dashboards can group complete flows. Business events such as `Paywall`, `Purchase`, `Onboarding`, and `Settings` should use the same convention.

## Tests

Use `MockLogService` from `ACLoggingTestSupport` to assert forwarded calls without hitting real providers:

```swift
import ACLogging
import ACLoggingTestSupport
import Testing

@Test("tracks paywall start")
func tracksPaywallStart() {
    let service = MockLogService()
    let manager = LogManager(services: [service])

    manager.trackEvent(PaywallEvent.viewStart(source: "home"))

    #expect(service.trackEventCalls.count == 1)
    #expect(service.trackEventCalls.first?.event.eventName == "Paywall_View_Start")
}
```
