/// Coordinates logging calls across one or more services.
public final class LogManager: Sendable {
    private let services: [any LogService]

    /// Creates a manager with the services that should receive every logging call.
    public init(services: [any LogService] = []) {
        self.services = services
    }

    /// Associates subsequent logs with a user profile on every service.
    public func identifyUser(userId: String, name: String? = nil, email: String? = nil) {
        services.forEach { service in
            service.identifyUser(userId: userId, name: name, email: email)
        }
    }

    /// Adds typed properties to the current user profile on every service.
    public func addUserProperties(_ properties: LogParameters, isHighPriority: Bool = false) {
        services.forEach { service in
            service.addUserProperties(properties, isHighPriority: isHighPriority)
        }
    }

    /// Deletes the current user profile from every service when supported.
    public func deleteUserProfile() {
        services.forEach { service in
            service.deleteUserProfile()
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
    public func trackScreenEvent(_ event: any LoggableEvent) {
        services.forEach { service in
            service.trackScreenEvent(event)
        }
    }
}
