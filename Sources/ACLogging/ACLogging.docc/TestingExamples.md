# Testing Examples

Use `ACLoggingTestSupport` to assert logging behavior without sending events to a real provider.

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
