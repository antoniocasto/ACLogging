import ACLogging
import ACLoggingTestSupport
import Foundation
import Testing

@Suite("LogManager")
struct LogManagerTests {
    @Test("identifyUser forwards to every service")
    func identifyUserForwardsToEveryService() {
        let firstService = MockLogService()
        let secondService = MockLogService()
        let manager = LogManager(services: [firstService, secondService])

        manager.identifyUser(userId: "user-1", name: "Antonio", email: "antonio@example.com")

        let expectedCall = MockLogService.IdentifyUserCall(
            userId: "user-1",
            name: "Antonio",
            email: "antonio@example.com"
        )
        #expect(firstService.identifyUserCalls == [expectedCall])
        #expect(secondService.identifyUserCalls == [expectedCall])
    }

    @Test("addUserProperties forwards to every service")
    func addUserPropertiesForwardsToEveryService() {
        let firstService = MockLogService()
        let secondService = MockLogService()
        let manager = LogManager(services: [firstService, secondService])
        let properties: LogParameters = [
            "plan": .string("pro"),
            "priority": .bool(true)
        ]

        manager.addUserProperties(properties, isHighPriority: true)

        let expectedCall = MockLogService.AddUserPropertiesCall(
            properties: properties,
            isHighPriority: true
        )
        #expect(firstService.addUserPropertiesCalls == [expectedCall])
        #expect(secondService.addUserPropertiesCalls == [expectedCall])
    }

    @Test("deleteUserProfile forwards to every service")
    func deleteUserProfileForwardsToEveryService() {
        let firstService = MockLogService()
        let secondService = MockLogService()
        let manager = LogManager(services: [firstService, secondService])

        manager.deleteUserProfile()

        #expect(firstService.deleteUserProfileCallCount == 1)
        #expect(secondService.deleteUserProfileCallCount == 1)
    }

    @Test("trackEvent forwards typed events to every service")
    func trackEventForwardsTypedEventsToEveryService() {
        let firstService = MockLogService()
        let secondService = MockLogService()
        let manager = LogManager(services: [firstService, secondService])
        let event = AnyLoggableEvent(
            eventName: "purchase_completed",
            parameters: ["amount": .double(42.5)],
            logType: .analytic
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
            logType: .info
        )

        manager.trackEvent(
            eventName: "settings_saved",
            parameters: ["section": .string("notifications")],
            logType: .info
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
            logType: .info
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
}
