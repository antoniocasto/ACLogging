/// An event that can be delivered to logging services.
public protocol LoggableEvent: Sendable {
    /// The stable event name.
    var eventName: String { get }

    /// Additional typed values attached to the event.
    var parameters: LogParameters? { get }

    /// Options that describe how logging services should handle the event.
    var options: LogOptions { get }
}

public extension LoggableEvent {
    /// Default event handling options.
    var options: LogOptions {
        LogOptions()
    }
}
