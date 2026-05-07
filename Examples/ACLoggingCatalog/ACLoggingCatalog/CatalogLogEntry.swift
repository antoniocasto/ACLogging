import ACLogging
import Foundation

struct CatalogLogEntry: Identifiable, Equatable {
    enum Kind: String, CaseIterable {
        case identifySubject = "Identify Subject"
        case clearIdentity = "Clear Identity"
        case trackEvent = "Track Event"
        case trackScreenEvent = "Screen Event"
    }

    let id = UUID()
    let date: Date
    let kind: Kind
    let name: String
    let parameters: LogParameters?
    let logType: LogType

    var formattedTime: String {
        date.formatted(date: .omitted, time: .standard)
    }

    var formattedParameters: String {
        guard let parameters, !parameters.isEmpty else {
            return "No parameters"
        }

        return parameters
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\(Self.format($0.value))" }
            .joined(separator: "\n")
    }

    private static func format(_ value: LogValue) -> String {
        switch value {
        case let .string(value):
            return "\"\(value)\""
        case let .int(value):
            return "\(value)"
        case let .double(value):
            return "\(value)"
        case let .bool(value):
            return "\(value)"
        case let .date(value):
            return value.formatted(date: .abbreviated, time: .standard)
        }
    }
}
