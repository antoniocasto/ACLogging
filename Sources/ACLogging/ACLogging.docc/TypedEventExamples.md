# Typed Event Examples

Model analytics and diagnostics as small typed values before sending them to `LogManager`.

Typed events are useful when a feature has stable names, repeated parameters, or specific privacy requirements. They keep event construction close to business code and keep adapter-specific decisions out of feature modules.

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

    var options: LogOptions {
        switch self {
        case .viewStart:
            return LogOptions(logType: .info)
        case .purchaseSuccess:
            return LogOptions(logType: .analytic)
        case .purchaseFail:
            return LogOptions(logType: .warning, parameterPrivacy: .hidden)
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

## Event Options

Use `LogOptions` to describe the event category and how parameters should be rendered by adapters:

```swift
LogOptions(logType: .analytic, parameterPrivacy: .private)
```

The default options are analytic events with private parameters. Override them when the destination should treat the event differently:

```swift
LogOptions(logType: .info, parameterPrivacy: .public)
LogOptions(logType: .warning, parameterPrivacy: .hidden)
```

`parameterPrivacy` is a destination-facing instruction. An adapter can map it to platform privacy APIs, remove parameters entirely, or translate it to the provider's equivalent privacy model.

## Convenience Events

Use `trackEvent(eventName:parameters:options:)` when a typed event would not add useful structure:

```swift
manager.trackEvent(
    eventName: "Settings_Save_Success",
    parameters: ["section": .string("notifications")],
    options: LogOptions(logType: .analytic)
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

Use consistent parameter keys across related events. This makes adapter output easier to query and reduces provider-specific mapping code.
