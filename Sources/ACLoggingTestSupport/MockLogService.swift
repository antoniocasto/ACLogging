import ACLogging
import Foundation

/// A log service test double that records every received logging call.
public final class MockLogService: LogService, @unchecked Sendable {
    /// A captured event-tracking call.
    public struct TrackEventCall: Sendable, Equatable {
        /// The event supplied to the service.
        public let event: AnyLoggableEvent

        /// Creates a captured event-tracking call.
        public init(event: AnyLoggableEvent) {
            self.event = event
        }
    }

    /// A captured screen-event tracking call.
    public struct TrackScreenEventCall: Sendable, Equatable {
        /// The event supplied to the service.
        public let event: AnyLoggableEvent

        /// Creates a captured screen-event tracking call.
        public init(event: AnyLoggableEvent) {
            self.event = event
        }
    }

    private let lock = NSLock()
    private var storedTrackEventCalls: [TrackEventCall] = []
    private var storedTrackScreenEventCalls: [TrackScreenEventCall] = []

    /// The recorded general event-tracking calls.
    public var trackEventCalls: [TrackEventCall] {
        lock.withLock { storedTrackEventCalls }
    }

    /// The recorded screen-event tracking calls.
    public var trackScreenEventCalls: [TrackScreenEventCall] {
        lock.withLock { storedTrackScreenEventCalls }
    }

    /// Creates a mock log service.
    public init() {}

    /// Records a general event-tracking call.
    public func trackEvent(_ event: any LoggableEvent) {
        lock.withLock {
            storedTrackEventCalls.append(TrackEventCall(event: AnyLoggableEvent(event)))
        }
    }

    /// Records a screen-event tracking call.
    public func trackScreenEvent(_ event: any LoggableEvent) {
        lock.withLock {
            storedTrackScreenEventCalls.append(
                TrackScreenEventCall(event: AnyLoggableEvent(event))
            )
        }
    }
}

/// An identity service test double that records every received identity call.
public final class MockLogIdentityService: LogIdentityService, @unchecked Sendable {
    /// A captured identify call.
    public struct IdentifyCall: Sendable, Equatable {
        /// The identity subject supplied to the service.
        public let subject: LogSubject

        /// Creates a captured identify call.
        public init(subject: LogSubject) {
            self.subject = subject
        }
    }

    private let lock = NSLock()
    private var storedIdentifyCalls: [IdentifyCall] = []
    private var storedClearIdentityCallCount = 0

    /// The recorded identify calls.
    public var identifyCalls: [IdentifyCall] {
        lock.withLock { storedIdentifyCalls }
    }

    /// The number of recorded clear-identity calls.
    public var clearIdentityCallCount: Int {
        lock.withLock { storedClearIdentityCallCount }
    }

    /// Creates a mock identity service.
    public init() {}

    /// Records an identify call.
    public func identify(_ subject: LogSubject) {
        lock.withLock {
            storedIdentifyCalls.append(IdentifyCall(subject: subject))
        }
    }

    /// Records a clear-identity call.
    public func clearIdentity() {
        lock.withLock {
            storedClearIdentityCallCount += 1
        }
    }
}

/// A test double that records both event and identity calls.
public final class MockCombinedLogService: LogService, LogIdentityService, @unchecked Sendable {
    private let logService = MockLogService()
    private let identityService = MockLogIdentityService()

    /// The recorded identify calls.
    public var identifyCalls: [MockLogIdentityService.IdentifyCall] {
        identityService.identifyCalls
    }

    /// The number of recorded clear-identity calls.
    public var clearIdentityCallCount: Int {
        identityService.clearIdentityCallCount
    }

    /// The recorded general event-tracking calls.
    public var trackEventCalls: [MockLogService.TrackEventCall] {
        logService.trackEventCalls
    }

    /// The recorded screen-event tracking calls.
    public var trackScreenEventCalls: [MockLogService.TrackScreenEventCall] {
        logService.trackScreenEventCalls
    }

    /// Creates a combined mock log and identity service.
    public init() {}

    /// Records an identify call.
    public func identify(_ subject: LogSubject) {
        identityService.identify(subject)
    }

    /// Records a clear-identity call.
    public func clearIdentity() {
        identityService.clearIdentity()
    }

    /// Records a general event-tracking call.
    public func trackEvent(_ event: any LoggableEvent) {
        logService.trackEvent(event)
    }

    /// Records a screen-event tracking call.
    public func trackScreenEvent(_ event: any LoggableEvent) {
        logService.trackScreenEvent(event)
    }
}
