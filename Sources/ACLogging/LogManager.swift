/// Coordinates logging calls across one or more services.
///
/// The manager performs synchronous fan-out to its configured services in the
/// order they were supplied and on the caller's current execution context.
/// Queueing, retries, persistence, and provider error handling are adapter
/// responsibilities.
public final class LogManager: Sendable {
    private let services: [any LogService]

    /// Creates a manager with the services that should receive every logging call.
    ///
    /// Passing no services creates a no-op manager.
    public init(services: [any LogService] = []) {
        self.services = services
    }

    /// Associates subsequent logs with a user profile on every service.
    ///
    /// The call is forwarded to each service synchronously.
    public func identifyUser(userId: String, name: String? = nil, email: String? = nil) {
        services.forEach { service in
            service.identifyUser(userId: userId, name: name, email: email)
        }
    }

    /// Adds typed properties to the current user profile on every service.
    ///
    /// The `isHighPriority` flag is forwarded unchanged to every service.
    public func addUserProperties(_ properties: LogParameters, isHighPriority: Bool = false) {
        services.forEach { service in
            service.addUserProperties(properties, isHighPriority: isHighPriority)
        }
    }

    /// Deletes the current user profile from every service when supported.
    ///
    /// Support for remote deletion depends on the configured services.
    public func deleteUserProfile() {
        services.forEach { service in
            service.deleteUserProfile()
        }
    }

    /// Tracks a general event on every service.
    ///
    /// The event is forwarded without transformation.
    public func trackEvent(_ event: any LoggableEvent) {
        services.forEach { service in
            service.trackEvent(event)
        }
    }

    /// Creates and tracks a general event on every service.
    ///
    /// This is a convenience overload for call sites that do not need a custom
    /// `LoggableEvent` type.
    ///
    /// - Parameters:
    ///   - eventName: A stable, non-sensitive event identifier.
    ///   - parameters: Optional typed metadata. Use `nil` when the event has no
    ///     parameters.
    ///   - logType: The provider-neutral event category. Defaults to
    ///     `.analytic`.
    public func trackEvent(
        eventName: String,
        parameters: LogParameters? = nil,
        logType: LogType = .analytic
    ) {
        trackEvent(
            AnyLoggableEvent(
                eventName: eventName,
                parameters: parameters,
                logType: logType
            )
        )
    }

    /// Tracks a screen-view event on every service.
    ///
    /// Screen events remain provider-neutral and are routed through
    /// `LogService.trackScreenEvent(_:)`.
    public func trackScreenEvent(_ event: any LoggableEvent) {
        services.forEach { service in
            service.trackScreenEvent(event)
        }
    }
}
