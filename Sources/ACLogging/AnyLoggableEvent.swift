/// A concrete, equatable event wrapper for any loggable event.
///
/// Use this type when tests or adapters need value semantics for an event that
/// was originally supplied as `any LoggableEvent`.
public struct AnyLoggableEvent: LoggableEvent, Sendable, Equatable {
    /// The stable event name.
    public let eventName: String

    /// Additional typed values attached to the event.
    public let parameters: LogParameters?

    /// The event category or severity.
    public let logType: LogType

    /// Creates an event from its individual values.
    public init(
        eventName: String,
        parameters: LogParameters? = nil,
        logType: LogType = .analytic
    ) {
        self.eventName = eventName
        self.parameters = parameters
        self.logType = logType
    }

    /// Creates an event by copying another loggable event.
    public init(_ event: any LoggableEvent) {
        self.init(
            eventName: event.eventName,
            parameters: event.parameters,
            logType: event.logType
        )
    }
}
