/// A destination capable of receiving user and event logging calls.
///
/// Services are responsible for provider-specific formatting, delivery, retry,
/// persistence, batching, SDK conversion, and privacy handling. `LogManager`
/// invokes services synchronously on the caller's current execution context and
/// does not catch service-side failures.
public protocol LogService: Sendable {
    /// Associates subsequent logs with a user profile.
    ///
    /// Adapters decide how optional profile fields map to their destination.
    func identifyUser(userId: String, name: String?, email: String?)

    /// Adds typed properties to the current user profile.
    ///
    /// `isHighPriority` is a provider-neutral hint. Adapters may ignore it when
    /// the destination does not support prioritized property delivery.
    func addUserProperties(_ properties: LogParameters, isHighPriority: Bool)

    /// Deletes the current user profile from the service when supported.
    ///
    /// Adapters that cannot delete remote profile data should document their
    /// fallback behavior.
    func deleteUserProfile()

    /// Tracks a general event.
    func trackEvent(_ event: any LoggableEvent)

    /// Tracks a screen-view event.
    ///
    /// Screen events use the same `LoggableEvent` model as general events so
    /// adapters can choose whether to route them differently.
    func trackScreenEvent(_ event: any LoggableEvent)
}
