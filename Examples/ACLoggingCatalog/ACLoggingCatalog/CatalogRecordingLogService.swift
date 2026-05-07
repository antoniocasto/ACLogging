import ACLogging
import Foundation

final class CatalogRecordingLogService: LogService, LogIdentityService, @unchecked Sendable {
    private weak var store: CatalogLogStore?

    init(store: CatalogLogStore) {
        self.store = store
    }

    func identify(_ subject: LogSubject) {
        var parameters = subject.properties
        if let id = subject.id {
            parameters["id"] = .string(id)
        }
        if let kind = subject.kind {
            parameters["kind"] = .string(kind)
        }
        record(kind: .identifySubject, name: "identify", parameters: parameters, logType: .info)
    }

    func clearIdentity() {
        record(kind: .clearIdentity, name: "clearIdentity", parameters: nil, logType: .warning)
    }

    func trackEvent(_ event: any LoggableEvent) {
        record(kind: .trackEvent, event: event)
    }

    func trackScreenEvent(_ event: any LoggableEvent) {
        record(kind: .trackScreenEvent, event: event)
    }

    private func record(kind: CatalogLogEntry.Kind, event: any LoggableEvent) {
        record(kind: kind, name: event.eventName, parameters: event.parameters, logType: event.options.logType)
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
