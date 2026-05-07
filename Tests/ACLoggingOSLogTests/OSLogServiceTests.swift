@testable import ACLoggingOSLog
import ACLogging
import Foundation
import OSLog
import Testing

@Suite("OSLogService")
struct OSLogServiceTests {
    @Test("maps log types to OSLog types")
    func mapsLogTypesToOSLogTypes() {
        #expect(OSLogService.osLogType(for: .info) == .info)
        #expect(OSLogService.osLogType(for: .analytic) == .default)
        #expect(OSLogService.osLogType(for: .warning) == .error)
        #expect(OSLogService.osLogType(for: .severe) == .fault)
    }

    @Test("formats parameters sorted by key")
    func formatsParametersSortedByKey() {
        let parameters: LogParameters = [
            "zeta": .bool(true),
            "amount": .double(42.5),
            "count": .int(3),
            "createdAt": .date(Date(timeIntervalSince1970: 0)),
            "name": .string("Paywall")
        ]

        let formatted = OSLogService.formattedParameters(parameters)

        #expect(
            formatted == "amount=42.5 count=3 createdAt=1970-01-01T00:00:00Z name=Paywall zeta=true"
        )
    }

    @Test("omits parameters when privacy is hidden")
    func omitsParametersWhenPrivacyIsHidden() {
        let event = AnyLoggableEvent(
            eventName: "Paywall_View_Start",
            parameters: ["source": .string("home")],
            options: LogOptions(logType: .analytic, parameterPrivacy: .hidden)
        )

        let message = OSLogService.message(for: event)

        #expect(message == "Paywall_View_Start")
    }

    @Test("includes sorted parameters when privacy allows rendering")
    func includesSortedParametersWhenPrivacyAllowsRendering() {
        let event = AnyLoggableEvent(
            eventName: "Paywall_View_Start",
            parameters: [
                "source": .string("home"),
                "attempt": .int(2)
            ]
        )

        let message = OSLogService.message(for: event)

        #expect(message == "Paywall_View_Start attempt=2 source=home")
    }

    @Test("uses log type from event options")
    func usesLogTypeFromEventOptions() {
        let event = AnyLoggableEvent(
            eventName: "Sync_Failed",
            options: LogOptions(logType: .severe)
        )

        #expect(OSLogService.osLogType(for: event.options.logType) == .fault)
    }
}
