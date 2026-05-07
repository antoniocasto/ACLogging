import ACLogging
import ACLoggingOSLog
import Foundation
import Observation

@MainActor
@Observable
final class CatalogLogStore {
    var entries: [CatalogLogEntry] = []
    var subjectID = "catalog-account-001"
    var subjectKind = "account"
    var subjectEmail = "catalog@example.com"
    var subjectRole = "owner"
    var plan = "pro"
    var isBetaTester = true

    @ObservationIgnored
    private lazy var recordingService = CatalogRecordingLogService(store: self)

    @ObservationIgnored
    lazy var logManager = LogManager(
        services: [
            recordingService,
            OSLogService(
                subsystem: "com.antoniocasto.ACLoggingCatalog",
                category: "Catalog"
            )
        ]
    )

    func record(
        kind: CatalogLogEntry.Kind,
        name: String,
        parameters: LogParameters?,
        logType: LogType
    ) {
        entries.insert(
            CatalogLogEntry(
                date: Date(),
                kind: kind,
                name: name,
                parameters: parameters,
                logType: logType
            ),
            at: 0
        )
    }

    func clearEntries() {
        entries.removeAll()
    }
}
