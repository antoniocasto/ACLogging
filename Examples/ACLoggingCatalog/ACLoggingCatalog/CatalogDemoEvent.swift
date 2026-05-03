import ACLogging
import Foundation

enum CatalogDemoEvent: LoggableEvent {
    case paywallViewStart(source: String)
    case paywallPurchaseSuccess(productID: String, amount: Double)
    case settingsSaveSuccess(section: String)
    case onboardingSkip(step: Int)
    case checkoutFail(reason: String, recoverable: Bool)
    case severeCrashMarker(date: Date)

    var eventName: String {
        switch self {
        case .paywallViewStart:
            return "Paywall_View_Start"
        case .paywallPurchaseSuccess:
            return "Paywall_Purchase_Success"
        case .settingsSaveSuccess:
            return "Settings_Save_Success"
        case .onboardingSkip:
            return "Onboarding_Skip"
        case .checkoutFail:
            return "Checkout_Submit_Fail"
        case .severeCrashMarker:
            return "Diagnostics_CrashMarker_Fail"
        }
    }

    var parameters: LogParameters? {
        switch self {
        case let .paywallViewStart(source):
            return ["source": .string(source)]
        case let .paywallPurchaseSuccess(productID, amount):
            return [
                "productId": .string(productID),
                "amount": .double(amount)
            ]
        case let .settingsSaveSuccess(section):
            return ["section": .string(section)]
        case let .onboardingSkip(step):
            return ["step": .int(step)]
        case let .checkoutFail(reason, recoverable):
            return [
                "reason": .string(reason),
                "recoverable": .bool(recoverable)
            ]
        case let .severeCrashMarker(date):
            return ["createdAt": .date(date)]
        }
    }

    var logType: LogType {
        switch self {
        case .paywallViewStart, .settingsSaveSuccess:
            return .info
        case .paywallPurchaseSuccess, .onboardingSkip:
            return .analytic
        case .checkoutFail:
            return .warning
        case .severeCrashMarker:
            return .severe
        }
    }
}
