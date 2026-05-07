/// Coordinates logging calls across one or more services.
public final class LogManager: Sendable {
    private let services: [any LogService]
    private let identityServices: [any LogIdentityService]

    /// Creates a manager with the services that should receive every logging call.
    ///
    /// Services that also conform to ``LogIdentityService`` are automatically used
    /// for identity calls. Pass `identityServices` when identity handling is owned
    /// by separate adapter objects.
    public init(
        services: [any LogService] = [],
        identityServices: [any LogIdentityService] = []
    ) {
        self.services = services
        self.identityServices = services.compactMap { service in
            service as? any LogIdentityService
        } + identityServices
    }

    /// Sets or updates the current identity subject on services that support it.
    public func identify(_ subject: LogSubject) {
        identityServices.forEach { service in
            service.identify(subject)
        }
    }

    /// Clears the current identity subject on services that support it.
    public func clearIdentity() {
        identityServices.forEach { service in
            service.clearIdentity()
        }
    }

    /// Tracks a general event on every service.
    public func trackEvent(_ event: any LoggableEvent) {
        services.forEach { service in
            service.trackEvent(event)
        }
    }

    /// Creates and tracks a general event on every service.
    public func trackEvent(
        eventName: String,
        parameters: LogParameters? = nil,
        options: LogOptions = LogOptions()
    ) {
        trackEvent(
            AnyLoggableEvent(
                eventName: eventName,
                parameters: parameters,
                options: options
            )
        )
    }

    /// Tracks a screen-view event on every service.
    public func trackScreenEvent(_ event: any LoggableEvent) {
        services.forEach { service in
            service.trackScreenEvent(event)
        }
    }
}
