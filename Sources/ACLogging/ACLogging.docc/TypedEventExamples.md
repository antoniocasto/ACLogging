# Typed Event Examples

Model analytics and diagnostics as small typed values before sending them to `LogManager`.

## Code Reference

This article describes the unreleased ACLogging API planned for `0.1.0`. After a public release is tagged, use the DocC article generated from the matching Git tag for that package version.

## Paywall Flow

Use one enum per business surface when events share naming and parameter conventions:

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
let manager = LogManager(services: [analyticsService])

manager.trackEvent(PaywallEvent.viewStart(source: "home"))
manager.trackEvent(PaywallEvent.purchaseSuccess(productId: "pro.monthly", amount: 9.99))
```

## Convenience Events

Use `trackEvent(eventName:parameters:logType:)` when a typed event would not add useful structure:

```swift
manager.trackEvent(
    eventName: "Settings_Save_Success",
    parameters: ["section": .string("notifications")],
    logType: .analytic
)
```

## Parameter Boundaries

Use `LogValue` for every parameter value so adapters can convert payloads deterministically:

```swift
let parameters: LogParameters = [
    "plan": .string("pro"),
    "attempt": .int(2),
    "amount": .double(9.99),
    "isTrial": .bool(false),
    "createdAt": .date(Date())
]
```
