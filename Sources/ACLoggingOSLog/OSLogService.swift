import ACLogging
import Foundation
import OSLog

/// A log service that writes ACLogging events through Apple's unified logging system.
public struct OSLogService: LogService, LogIdentityService {
    private let logger: Logger

    /// Creates an OSLog-backed service.
    ///
    /// - Parameters:
    ///   - subsystem: The unified logging subsystem. Defaults to the app bundle identifier, then `ACLogging`.
    ///   - category: The unified logging category.
    public init(
        subsystem: String? = nil,
        category: String = "default"
    ) {
        let resolvedSubsystem = subsystem ?? Bundle.main.bundleIdentifier ?? "ACLogging"
        self.logger = Logger(subsystem: resolvedSubsystem, category: category)
    }

    /// Logs an identity subject update.
    public func identify(_ subject: LogSubject) {
        log(
            name: "IdentifySubject",
            parameters: Self.parameters(for: subject),
            options: LogOptions(logType: .info)
        )
    }

    /// Logs an identity subject clearing event.
    public func clearIdentity() {
        log(
            name: "ClearIdentity",
            parameters: nil,
            options: LogOptions(logType: .warning)
        )
    }

    /// Logs a general event using the event's log type.
    public func trackEvent(_ event: any LoggableEvent) {
        log(name: event.eventName, parameters: event.parameters, options: event.options)
    }

    /// Logs a screen event using the same formatting as general events.
    public func trackScreenEvent(_ event: any LoggableEvent) {
        trackEvent(event)
    }

    private func log(name: String, parameters: LogParameters?, options: LogOptions) {
        let level = Self.osLogType(for: options.logType)
        let formattedParameters = Self.formattedParameters(
            parameters,
            parameterPrivacy: options.parameterPrivacy
        )

        guard let formattedParameters else {
            logger.log(level: level, "\(name, privacy: .public)")
            return
        }

        switch options.parameterPrivacy {
        case .hidden:
            logger.log(level: level, "\(name, privacy: .public)")
        case .private:
            logger.log(level: level, "\(name, privacy: .public) \(formattedParameters, privacy: .private)")
        case .public:
            logger.log(level: level, "\(name, privacy: .public) \(formattedParameters, privacy: .public)")
        }
    }
}

extension OSLogService {
    static func osLogType(for logType: LogType) -> OSLogType {
        switch logType {
        case .info:
            return .info
        case .analytic:
            return .default
        case .warning:
            return .error
        case .severe:
            return .fault
        }
    }

    static func message(for event: any LoggableEvent) -> String {
        message(
            eventName: event.eventName,
            parameters: event.parameters,
            parameterPrivacy: event.options.parameterPrivacy
        )
    }

    static func message(
        eventName: String,
        parameters: LogParameters?,
        parameterPrivacy: LogParameterPrivacy
    ) -> String {
        guard let formattedParameters = formattedParameters(
            parameters,
            parameterPrivacy: parameterPrivacy
        ) else {
            return eventName
        }

        return "\(eventName) \(formattedParameters)"
    }

    static func formattedParameters(
        _ parameters: LogParameters?,
        parameterPrivacy: LogParameterPrivacy
    ) -> String? {
        guard parameterPrivacy != .hidden else {
            return nil
        }

        guard let parameters else {
            return nil
        }

        let formattedParameters = formattedParameters(parameters)
        guard !formattedParameters.isEmpty else {
            return nil
        }

        return formattedParameters
    }

    static func formattedParameters(_ parameters: LogParameters) -> String {
        parameters
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\(formattedValue($0.value))" }
            .joined(separator: " ")
    }

    static func parameters(for subject: LogSubject) -> LogParameters {
        var parameters = subject.properties

        if let id = subject.id {
            parameters["id"] = .string(id)
        }

        if let kind = subject.kind {
            parameters["kind"] = .string(kind)
        }

        return parameters
    }

    private static func formattedValue(_ value: LogValue) -> String {
        switch value {
        case let .string(value):
            return value
        case let .int(value):
            return "\(value)"
        case let .double(value):
            return "\(value)"
        case let .bool(value):
            return "\(value)"
        case let .date(value):
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            return formatter.string(from: value)
        }
    }
}
