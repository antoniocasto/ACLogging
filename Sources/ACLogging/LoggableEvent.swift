/// An event that can be delivered to logging services.
///
/// Event names should be stable, non-sensitive identifiers owned by the
/// consuming app. Parameters provide optional metadata and should not be used
/// as the only way to distinguish unrelated event types.
public protocol LoggableEvent: Sendable {
    /// The stable event name.
    ///
    /// Use app-level naming conventions that remain meaningful outside the
    /// implementation that emits the event.
    var eventName: String { get }

    /// Additional typed values attached to the event.
    ///
    /// Use `nil` when an event has no parameters.
    var parameters: LogParameters? { get }

    /// The event category or severity.
    var logType: LogType { get }
}
