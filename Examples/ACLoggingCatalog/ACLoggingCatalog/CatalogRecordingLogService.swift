import ACLogging
import Foundation

final class CatalogRecordingLogService: LogService, @unchecked Sendable {
    private weak var store: CatalogLogStore?

    init(store: CatalogLogStore) {
        self.store = store
    }

    func identifyUser(userId: String, name: String?, email: String?) {
        var parameters: LogParameters = ["userId": .string(userId)]
        if let name {
            parameters["name"] = .string(name)
        }
        if let email {
            parameters["email"] = .string(email)
        }
        record(kind: .identifyUser, name: "identifyUser", parameters: parameters, logType: .info)
    }

    func addUserProperties(_ properties: LogParameters, isHighPriority: Bool) {
        var parameters = properties
        parameters["isHighPriority"] = .bool(isHighPriority)
        record(kind: .addUserProperties, name: "addUserProperties", parameters: parameters, logType: .info)
    }

    func deleteUserProfile() {
        record(kind: .deleteUserProfile, name: "deleteUserProfile", parameters: nil, logType: .warning)
    }

    func trackEvent(_ event: any LoggableEvent) {
        record(kind: .trackEvent, event: event)
    }

    func trackScreenEvent(_ event: any LoggableEvent) {
        record(kind: .trackScreenEvent, event: event)
    }

    private func record(kind: CatalogLogEntry.Kind, event: any LoggableEvent) {
        record(kind: kind, name: event.eventName, parameters: event.parameters, logType: event.logType)
    }

    private func record(
        kind: CatalogLogEntry.Kind,
        name: String,
        parameters: LogParameters?,
        logType: LogType
    ) {
        Task { @MainActor [weak store] in
            store?.record(kind: kind, name: name, parameters: parameters, logType: logType)
        }
    }
}
