/// A destination capable of receiving user and event logging calls.
public protocol LogService: Sendable {
    /// Associates subsequent logs with a user profile.
    func identifyUser(userId: String, name: String?, email: String?)

    /// Adds typed properties to the current user profile.
    func addUserProperties(_ properties: LogParameters, isHighPriority: Bool)

    /// Deletes the current user profile from the service when supported.
    func deleteUserProfile()

    /// Tracks a general event.
    func trackEvent(_ event: any LoggableEvent)

    /// Tracks a screen-view event.
    func trackScreenEvent(_ event: any LoggableEvent)
}
