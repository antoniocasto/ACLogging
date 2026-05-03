import ACLogging
import SwiftUI

struct EventScenariosView: View {
    let store: CatalogLogStore
    @State private var eventName = "Catalog_Custom_Start"
    @State private var selectedLogType = LogType.analytic
    @State private var source = "catalog"
    @State private var attempt = 1
    @State private var amount = 19.99
    @State private var enabled = true

    var body: some View {
        NavigationStack {
            List {
                Section("Typed and convenience scenarios") {
                    ForEach(CatalogScenario.all) { scenario in
                        Button {
                            scenario.run(store.logManager)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(scenario.title)
                                        .font(.headline)
                                    Spacer()
                                    LogTypeBadge(logType: scenario.logType)
                                }
                                Text(scenario.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(scenario.eventName)
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Custom event builder") {
                    TextField("Event name", text: $eventName)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    Picker("Log type", selection: $selectedLogType) {
                        Text("Info").tag(LogType.info)
                        Text("Analytic").tag(LogType.analytic)
                        Text("Warning").tag(LogType.warning)
                        Text("Severe").tag(LogType.severe)
                    }

                    TextField("Source", text: $source)

                    Stepper("Attempt: \(attempt)", value: $attempt, in: 1...20)

                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Amount", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 120)
                    }

                    Toggle("Enabled", isOn: $enabled)

                    Button {
                        store.logManager.trackEvent(
                            eventName: eventName,
                            parameters: [
                                "source": .string(source),
                                "attempt": .int(attempt),
                                "amount": .double(amount),
                                "enabled": .bool(enabled),
                                "createdAt": .date(Date())
                            ],
                            logType: selectedLogType
                        )
                    } label: {
                        Label("Track custom event", systemImage: "paperplane")
                    }
                }
            }
            .navigationTitle("Events")
        }
    }
}
