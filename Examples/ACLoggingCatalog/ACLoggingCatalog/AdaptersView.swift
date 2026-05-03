import ACLogging
import SwiftUI

struct AdaptersView: View {
    let store: CatalogLogStore
    @State private var shouldPrintParameters = true

    var body: some View {
        NavigationStack {
            List {
                Section("Provider matrix") {
                    adapter(
                        name: "In-app recorder",
                        status: "Enabled",
                        detail: "Captures every LogService call for visible feedback.",
                        capabilities: "Events, screens, identity, properties, delete"
                    )
                    adapter(
                        name: "OSLog",
                        status: "Enabled",
                        detail: "Writes to Apple unified logging with deterministic parameter formatting.",
                        capabilities: "Events, screens, identity, properties, delete"
                    )
                    adapter(
                        name: "Firebase",
                        status: "Future slot",
                        detail: "Will convert LogValue primitives at the adapter boundary.",
                        capabilities: "Events, screens, user properties"
                    )
                    adapter(
                        name: "Mixpanel",
                        status: "Future slot",
                        detail: "Will split event properties and profile properties through the same core API.",
                        capabilities: "Events, identity, profile properties"
                    )
                    adapter(
                        name: "Custom provider",
                        status: "Template",
                        detail: "Implement LogService and convert LoggableEvent for your provider.",
                        capabilities: "Defined by the service implementation"
                    )
                }

                Section("OSLog preview") {
                    Toggle("Print parameters", isOn: $shouldPrintParameters)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Formatted message")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(
                            osLogPreviewMessage(
                                eventName: "Paywall_Purchase_Success",
                                parameters: previewParameters,
                                shouldPrintParameters: shouldPrintParameters
                            )
                        )
                        .font(.caption.monospaced())
                        .textSelection(.enabled)
                    }
                    Button {
                        store.logManager.trackEvent(
                            eventName: "Adapters_OSLog_Preview",
                            parameters: previewParameters,
                            logType: .info
                        )
                    } label: {
                        Label("Send OSLog preview event", systemImage: "waveform")
                    }
                }

                Section("LogType mapping") {
                    mapping("info", "OSLogType.info")
                    mapping("analytic", "OSLogType.default")
                    mapping("warning", "OSLogType.error")
                    mapping("severe", "OSLogType.fault")
                }
            }
            .navigationTitle("Adapters")
        }
    }

    private var previewParameters: LogParameters {
        [
            "amount": .double(9.99),
            "productId": .string("pro_monthly"),
            "createdAt": .date(Date(timeIntervalSince1970: 0))
        ]
    }

    private func osLogPreviewMessage(
        eventName: String,
        parameters: LogParameters,
        shouldPrintParameters: Bool
    ) -> String {
        guard shouldPrintParameters else {
            return eventName
        }

        let formatted = parameters
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\(format($0.value))" }
            .joined(separator: " ")

        return formatted.isEmpty ? eventName : "\(eventName) \(formatted)"
    }

    private func format(_ value: LogValue) -> String {
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
            return ISO8601DateFormatter().string(from: value)
        }
    }

    private func adapter(
        name: String,
        status: String,
        detail: String,
        capabilities: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(name)
                    .font(.headline)
                Spacer()
                Text(status)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(status == "Enabled" ? .green : .secondary)
            }
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(capabilities)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func mapping(_ logType: String, _ osLogType: String) -> some View {
        HStack {
            Text(logType)
                .font(.body.monospaced())
            Spacer()
            Text(osLogType)
                .font(.body.monospaced())
                .foregroundStyle(.secondary)
        }
    }
}
