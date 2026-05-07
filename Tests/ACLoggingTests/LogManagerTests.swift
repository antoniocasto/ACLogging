import ACLogging
import ACLoggingTestSupport
import Foundation
import Testing

@Suite("LogManager")
struct LogManagerTests {
    @Test("identify forwards subjects only to identity services")
    func identifyForwardsSubjectsOnlyToIdentityServices() {
        let eventOnlyService = MockLogService()
        let identityService = MockLogIdentityService()
        let manager = LogManager(
            services: [eventOnlyService],
            identityServices: [identityService]
        )
        let subject = LogSubject(
            id: "account-1",
            kind: "account",
            properties: [
                "email": .string("antonio@example.com"),
                "plan": .string("pro")
            ]
        )

        manager.identify(subject)

        #expect(identityService.identifyCalls == [.init(subject: subject)])
        #expect(eventOnlyService.trackEventCalls.isEmpty)
        #expect(eventOnlyService.trackScreenEventCalls.isEmpty)
    }

    @Test("clearIdentity forwards only to identity services")
    func clearIdentityForwardsOnlyToIdentityServices() {
        let eventOnlyService = MockLogService()
        let identityService = MockLogIdentityService()
        let manager = LogManager(
            services: [eventOnlyService],
            identityServices: [identityService]
        )

        manager.clearIdentity()

        #expect(identityService.clearIdentityCallCount == 1)
        #expect(eventOnlyService.trackEventCalls.isEmpty)
        #expect(eventOnlyService.trackScreenEventCalls.isEmpty)
    }

    @Test("identity services are discovered from logging services")
    func identityServicesAreDiscoveredFromLoggingServices() {
        let service = MockCombinedLogService()
        let manager = LogManager(services: [service])
        let subject = LogSubject(id: "tenant-1", kind: "tenant")

        manager.identify(subject)
        manager.clearIdentity()

        #expect(service.identifyCalls == [.init(subject: subject)])
        #expect(service.clearIdentityCallCount == 1)
    }

    @Test("trackEvent forwards typed events to every service")
    func trackEventForwardsTypedEventsToEveryService() {
        let firstService = MockLogService()
        let secondService = MockLogService()
        let manager = LogManager(services: [firstService, secondService])
        let event = AnyLoggableEvent(
            eventName: "purchase_completed",
            parameters: ["amount": .double(42.5)],
            options: LogOptions(logType: .analytic)
        )

        manager.trackEvent(event)

        #expect(firstService.trackEventCalls == [.init(event: event)])
        #expect(secondService.trackEventCalls == [.init(event: event)])
    }

    @Test("trackEvent convenience wraps event data")
    func trackEventConvenienceWrapsEventData() {
        let firstService = MockLogService()
        let secondService = MockLogService()
        let manager = LogManager(services: [firstService, secondService])
        let expectedEvent = AnyLoggableEvent(
            eventName: "settings_saved",
            parameters: ["section": .string("notifications")],
            options: LogOptions(logType: .info, parameterPrivacy: .hidden)
        )

        manager.trackEvent(
            eventName: "settings_saved",
            parameters: ["section": .string("notifications")],
            options: LogOptions(logType: .info, parameterPrivacy: .hidden)
        )

        #expect(firstService.trackEventCalls == [.init(event: expectedEvent)])
        #expect(secondService.trackEventCalls == [.init(event: expectedEvent)])
    }

    @Test("trackScreenEvent forwards screen events to every service")
    func trackScreenEventForwardsToEveryService() {
        let firstService = MockLogService()
        let secondService = MockLogService()
        let manager = LogManager(services: [firstService, secondService])
        let event = AnyLoggableEvent(
            eventName: "home_screen",
            parameters: ["source": .string("tab")],
            options: LogOptions(logType: .info)
        )

        manager.trackScreenEvent(event)

        #expect(firstService.trackScreenEventCalls == [.init(event: event)])
        #expect(secondService.trackScreenEventCalls == [.init(event: event)])
    }

    @Test("log values support codable round trips")
    func logValuesSupportCodableRoundTrips() throws {
        let parameters: LogParameters = [
            "name": .string("Paywall"),
            "count": .int(3),
            "amount": .double(42.5),
            "enabled": .bool(true),
            "createdAt": .date(Date(timeIntervalSince1970: 0))
        ]

        let data = try JSONEncoder().encode(parameters)
        let decoded = try JSONDecoder().decode(LogParameters.self, from: data)

        #expect(decoded == parameters)
    }

    @Test("events use analytic private options by default")
    func eventsUseAnalyticPrivateOptionsByDefault() {
        let event = AnyLoggableEvent(eventName: "Paywall_View_Start")

        #expect(event.options == LogOptions(logType: .analytic, parameterPrivacy: .private))
    }
}
