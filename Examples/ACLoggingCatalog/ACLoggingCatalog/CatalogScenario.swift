import ACLogging
import Foundation

@MainActor
struct CatalogScenario: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let eventName: String
    let logType: LogType
    let run: (LogManager) -> Void

    static let all: [CatalogScenario] = [
        CatalogScenario(
            id: "paywall-start",
            title: "Paywall view starts",
            subtitle: "Typed event with a string parameter.",
            eventName: "Paywall_View_Start",
            logType: .info
        ) { manager in
            manager.trackEvent(CatalogDemoEvent.paywallViewStart(source: "catalog"))
        },
        CatalogScenario(
            id: "purchase-success",
            title: "Purchase succeeds",
            subtitle: "Typed analytic event with string and double parameters.",
            eventName: "Paywall_Purchase_Success",
            logType: .analytic
        ) { manager in
            manager.trackEvent(
                CatalogDemoEvent.paywallPurchaseSuccess(
                    productID: "pro_monthly",
                    amount: 9.99
                )
            )
        },
        CatalogScenario(
            id: "settings-save",
            title: "Settings save succeeds",
            subtitle: "Convenience API event using LogParameters directly.",
            eventName: "Settings_Save_Success",
            logType: .analytic
        ) { manager in
            manager.trackEvent(
                eventName: "Settings_Save_Success",
                parameters: [
                    "section": .string("notifications"),
                    "attempt": .int(1),
                    "isEnabled": .bool(true)
                ],
                logType: .analytic
            )
        },
        CatalogScenario(
            id: "onboarding-skip",
            title: "Onboarding step skipped",
            subtitle: "Typed event with an integer step parameter.",
            eventName: "Onboarding_Skip",
            logType: .analytic
        ) { manager in
            manager.trackEvent(CatalogDemoEvent.onboardingSkip(step: 3))
        },
        CatalogScenario(
            id: "checkout-fail",
            title: "Checkout fails",
            subtitle: "Warning event with a recoverable failure parameter.",
            eventName: "Checkout_Submit_Fail",
            logType: .warning
        ) { manager in
            manager.trackEvent(
                CatalogDemoEvent.checkoutFail(
                    reason: "card_declined",
                    recoverable: true
                )
            )
        },
        CatalogScenario(
            id: "severe-marker",
            title: "Severe diagnostic marker",
            subtitle: "Severe event with a date parameter.",
            eventName: "Diagnostics_CrashMarker_Fail",
            logType: .severe
        ) { manager in
            manager.trackEvent(CatalogDemoEvent.severeCrashMarker(date: Date()))
        }
    ]
}
