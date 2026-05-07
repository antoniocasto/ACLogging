/// A concrete, equatable event wrapper for any loggable event.
public struct AnyLoggableEvent: LoggableEvent, Sendable, Equatable {
    /// The stable event name.
    public let eventName: String

    /// Additional typed values attached to the event.
    public let parameters: LogParameters?

    /// Options that describe how logging services should handle the event.
    public let options: LogOptions

    /// Creates an event from its individual values.
    public init(
        eventName: String,
        parameters: LogParameters? = nil,
        options: LogOptions = LogOptions()
    ) {
        self.eventName = eventName
        self.parameters = parameters
        self.options = options
    }

    /// Creates an event by copying another loggable event.
    public init(_ event: any LoggableEvent) {
        self.init(
            eventName: event.eventName,
            parameters: event.parameters,
            options: event.options
        )
    }
}
