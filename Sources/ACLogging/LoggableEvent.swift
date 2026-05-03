/// An event that can be delivered to logging services.
public protocol LoggableEvent: Sendable {
    /// The stable event name.
    var eventName: String { get }

    /// Additional typed values attached to the event.
    var parameters: LogParameters? { get }

    /// The event category or severity.
    var logType: LogType { get }
}
