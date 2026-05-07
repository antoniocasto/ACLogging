import ACLogging
import Foundation

/// A log service test double that records every received logging call.
///
/// Recorded calls are protected by a lock. Public accessors return snapshots in
/// call order, and existential events are copied into `AnyLoggableEvent` when
/// they are recorded.
public final class MockLogService: LogService, @unchecked Sendable {
    /// A captured identify-user call.
    public struct IdentifyUserCall: Sendable, Equatable {
        /// The user identifier supplied to the service.
        public let userId: String

        /// The optional display name supplied to the service.
        public let name: String?

        /// The optional email address supplied to the service.
        public let email: String?

        /// Creates a captured identify-user call.
        public init(userId: String, name: String?, email: String?) {
            self.userId = userId
            self.name = name
            self.email = email
        }
    }

    /// A captured user-properties call.
    public struct AddUserPropertiesCall: Sendable, Equatable {
        /// The properties supplied to the service.
        public let properties: LogParameters

        /// Whether the call was marked as high priority.
        public let isHighPriority: Bool

        /// Creates a captured user-properties call.
        public init(properties: LogParameters, isHighPriority: Bool) {
            self.properties = properties
            self.isHighPriority = isHighPriority
        }
    }

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
    private var storedIdentifyUserCalls: [IdentifyUserCall] = []
    private var storedAddUserPropertiesCalls: [AddUserPropertiesCall] = []
    private var storedDeleteUserProfileCallCount = 0
    private var storedTrackEventCalls: [TrackEventCall] = []
    private var storedTrackScreenEventCalls: [TrackScreenEventCall] = []

    /// The recorded identify-user calls.
    ///
    /// The returned array is a snapshot.
    public var identifyUserCalls: [IdentifyUserCall] {
        lock.withLock { storedIdentifyUserCalls }
    }

    /// The recorded user-properties calls.
    ///
    /// The returned array is a snapshot.
    public var addUserPropertiesCalls: [AddUserPropertiesCall] {
        lock.withLock { storedAddUserPropertiesCalls }
    }

    /// The number of recorded delete-user-profile calls.
    public var deleteUserProfileCallCount: Int {
        lock.withLock { storedDeleteUserProfileCallCount }
    }

    /// The recorded general event-tracking calls.
    ///
    /// The returned array is a snapshot.
    public var trackEventCalls: [TrackEventCall] {
        lock.withLock { storedTrackEventCalls }
    }

    /// The recorded screen-event tracking calls.
    ///
    /// The returned array is a snapshot.
    public var trackScreenEventCalls: [TrackScreenEventCall] {
        lock.withLock { storedTrackScreenEventCalls }
    }

    /// Creates a mock log service.
    public init() {}

    /// Records an identify-user call.
    public func identifyUser(userId: String, name: String?, email: String?) {
        lock.withLock {
            storedIdentifyUserCalls.append(
                IdentifyUserCall(userId: userId, name: name, email: email)
            )
        }
    }

    /// Records a user-properties call.
    public func addUserProperties(_ properties: LogParameters, isHighPriority: Bool) {
        lock.withLock {
            storedAddUserPropertiesCalls.append(
                AddUserPropertiesCall(
                    properties: properties,
                    isHighPriority: isHighPriority
                )
            )
        }
    }

    /// Records a delete-user-profile call.
    public func deleteUserProfile() {
        lock.withLock {
            storedDeleteUserProfileCallCount += 1
        }
    }

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
