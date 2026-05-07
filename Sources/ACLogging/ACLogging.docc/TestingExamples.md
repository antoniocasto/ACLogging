# Testing Examples

Use `ACLoggingTestSupport` to assert logging behavior without sending events to a real provider.

## Code Reference

This article describes the unreleased ACLogging API planned for `0.1.0`. After a public release is tagged, use the DocC article generated from the matching Git tag for that package version.

## Assert Event Forwarding

```swift
import ACLogging
import ACLoggingTestSupport
import Testing

@Test("tracks paywall start")
func tracksPaywallStart() {
    let service = MockLogService()
    let manager = LogManager(services: [service])

    manager.trackEvent(
        eventName: "Paywall_View_Start",
        parameters: ["source": .string("home")],
        logType: .analytic
    )

    #expect(service.trackEventCalls.count == 1)
    #expect(service.trackEventCalls.first?.event.eventName == "Paywall_View_Start")
    #expect(service.trackEventCalls.first?.event.parameters == ["source": .string("home")])
}
```

## Assert Multiple Services

`LogManager` forwards every call to every configured service:

```swift
let firstService = MockLogService()
let secondService = MockLogService()
let manager = LogManager(services: [firstService, secondService])

manager.deleteUserProfile()

#expect(firstService.deleteUserProfileCallCount == 1)
#expect(secondService.deleteUserProfileCallCount == 1)
```

## Test User Properties

```swift
let service = MockLogService()
let manager = LogManager(services: [service])

manager.addUserProperties(
    [
        "plan": .string("pro"),
        "isBetaTester": .bool(true)
    ],
    isHighPriority: true
)

#expect(service.addUserPropertiesCalls.first?.isHighPriority == true)
#expect(service.addUserPropertiesCalls.first?.properties["plan"] == .string("pro"))
```

## Test SwiftUI Lifecycle Events

`ACLoggingSwiftUI` keeps lifecycle event construction deterministic. The package test suite verifies that `screenLogging(name:)` creates analytic screen events with the expected suffixes:

- `<ScreenName>_appear`
- `<ScreenName>_disappear`

This keeps naming regressions visible without requiring provider SDKs or network calls.
