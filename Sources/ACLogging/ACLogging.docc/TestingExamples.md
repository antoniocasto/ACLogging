# Testing Examples

Use `ACLoggingTestSupport` to assert logging behavior without sending events to a real provider.

`MockLogService` records every event passed to `trackEvent(_:)` and `trackScreenEvent(_:)`. `MockLogIdentityService` records identity updates and clear calls.

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
        options: LogOptions(logType: .analytic)
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

manager.trackEvent(eventName: "Paywall_View_Start")

#expect(firstService.trackEventCalls.count == 1)
#expect(secondService.trackEventCalls.count == 1)
```

## Assert Screen Events

Screen events are recorded separately from general events:

```swift
let service = MockLogService()
let manager = LogManager(services: [service])

manager.trackScreenEvent(
    AnyLoggableEvent(
        eventName: "Paywall_appear",
        parameters: nil
    )
)

#expect(service.trackScreenEventCalls.count == 1)
#expect(service.trackScreenEventCalls.first?.event.eventName == "Paywall_appear")
```

## Test Identity Subjects

```swift
let identityService = MockLogIdentityService()
let manager = LogManager(identityServices: [identityService])

let subject = LogSubject(
    id: "account-123",
    kind: "account",
    properties: [
        "plan": .string("pro")
    ]
)

manager.identify(subject)
manager.clearIdentity()

#expect(identityService.identifyCalls == [.init(subject: subject)])
#expect(identityService.clearIdentityCallCount == 1)
```

## Keep Tests Provider-Neutral

Prefer assertions against event names, parameter values, options, and identity subjects. Adapter-specific formatting belongs in adapter tests, not feature tests that only need to prove the app emitted the right event.
