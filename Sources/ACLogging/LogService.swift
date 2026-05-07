/// A destination capable of receiving event logging calls.
public protocol LogService: Sendable {
    /// Tracks a general event.
    func trackEvent(_ event: any LoggableEvent)

    /// Tracks a screen-view event.
    func trackScreenEvent(_ event: any LoggableEvent)
}
