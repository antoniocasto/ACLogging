/// Options that describe how a log event should be handled by logging services.
public struct LogOptions: Sendable, Equatable {
    /// The event category or severity.
    public let logType: LogType

    /// The privacy level to apply to event parameters.
    public let parameterPrivacy: LogParameterPrivacy

    /// Creates log handling options.
    public init(
        logType: LogType = .analytic,
        parameterPrivacy: LogParameterPrivacy = .private
    ) {
        self.logType = logType
        self.parameterPrivacy = parameterPrivacy
    }
}

/// The privacy level to apply when a service renders event parameters.
public enum LogParameterPrivacy: Sendable, Equatable {
    /// Do not render event parameters.
    case hidden

    /// Render event parameters as private values when the destination supports privacy levels.
    case `private`

    /// Render event parameters as public values.
    case `public`
}
