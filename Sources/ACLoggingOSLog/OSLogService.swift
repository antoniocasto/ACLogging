import ACLogging
import Foundation
import OSLog

/// A log service that writes ACLogging events through Apple's unified logging system.
///
/// Event names are written as public unified-log content. When
/// `shouldPrintParameters` is `true`, rendered parameters are also public, so
/// apps should avoid sending personally identifiable or sensitive values to this
/// adapter unless that visibility is intentional.
public struct OSLogService: LogService {
    private let logger: Logger
    private let shouldPrintParameters: Bool

    /// Creates an OSLog-backed service.
    ///
    /// - Parameters:
    ///   - subsystem: The unified logging subsystem. Defaults to the app bundle identifier, then `ACLogging`.
    ///   - category: The unified logging category.
    ///   - shouldPrintParameters: Whether event and user parameters should be included in public log messages. Passing `false` still logs event names publicly.
    public init(
        subsystem: String? = nil,
        category: String = "default",
        shouldPrintParameters: Bool = true
    ) {
        let resolvedSubsystem = subsystem ?? Bundle.main.bundleIdentifier ?? "ACLogging"
        self.logger = Logger(subsystem: resolvedSubsystem, category: category)
        self.shouldPrintParameters = shouldPrintParameters
    }

    /// Logs a user-identification event.
    ///
    /// The user identifier and optional profile fields are rendered as
    /// parameters when `shouldPrintParameters` is enabled.
    public func identifyUser(userId: String, name: String?, email: String?) {
        var parameters: LogParameters = ["userId": .string(userId)]

        if let name {
            parameters["name"] = .string(name)
        }

        if let email {
            parameters["email"] = .string(email)
        }

        log(name: "IdentifyUser", parameters: parameters, type: .info)
    }

    /// Logs user properties.
    ///
    /// Properties are rendered as public parameters when
    /// `shouldPrintParameters` is enabled.
    public func addUserProperties(_ properties: LogParameters, isHighPriority: Bool) {
        var parameters = properties
        parameters["isHighPriority"] = .bool(isHighPriority)
        log(name: "AddUserProperties", parameters: parameters, type: .info)
    }

    /// Logs a user-profile deletion event.
    public func deleteUserProfile() {
        log(name: "DeleteUserProfile", parameters: [:], type: .warning)
    }

    /// Logs a general event using the event's log type.
    ///
    /// Mapping is `.info` to `OSLogType.info`, `.analytic` to
    /// `OSLogType.default`, `.warning` to `OSLogType.error`, and `.severe` to
    /// `OSLogType.fault`.
    public func trackEvent(_ event: any LoggableEvent) {
        logger.log(
            level: Self.osLogType(for: event.logType),
            "\(Self.message(for: event, shouldPrintParameters: shouldPrintParameters), privacy: .public)"
        )
    }

    /// Logs a screen event using the same formatting as general events.
    public func trackScreenEvent(_ event: any LoggableEvent) {
        trackEvent(event)
    }

    private func log(name: String, parameters: LogParameters, type: LogType) {
        logger.log(
            level: Self.osLogType(for: type),
            "\(Self.message(eventName: name, parameters: parameters, shouldPrintParameters: shouldPrintParameters), privacy: .public)"
        )
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

    static func message(for event: any LoggableEvent, shouldPrintParameters: Bool) -> String {
        message(
            eventName: event.eventName,
            parameters: event.parameters,
            shouldPrintParameters: shouldPrintParameters
        )
    }

    static func message(
        eventName: String,
        parameters: LogParameters?,
        shouldPrintParameters: Bool
    ) -> String {
        guard shouldPrintParameters else {
            return eventName
        }

        guard let parameters else {
            return eventName
        }

        let formattedParameters = formattedParameters(parameters)
        guard !formattedParameters.isEmpty else {
            return eventName
        }

        return "\(eventName) \(formattedParameters)"
    }

    static func formattedParameters(_ parameters: LogParameters) -> String {
        parameters
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\(formattedValue($0.value))" }
            .joined(separator: " ")
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
