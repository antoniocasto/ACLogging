import SwiftUI

struct ConsoleView: View {
    let store: CatalogLogStore

    var body: some View {
        NavigationStack {
            List {
                if store.entries.isEmpty {
                    ContentUnavailableView(
                        "No calls captured",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Run a scenario, user action, or SwiftUI screen demo to capture LogService calls.")
                    )
                } else {
                    ForEach(store.entries) { entry in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .firstTextBaseline) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.name)
                                        .font(.headline)
                                    Text("\(entry.kind.rawValue) at \(entry.formattedTime)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                LogTypeBadge(logType: entry.logType)
                            }
                            ParameterPreview(parameters: entry.parameters)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Console")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.clearEntries()
                    } label: {
                        Label("Clear", systemImage: "trash")
                    }
                    .disabled(store.entries.isEmpty)
                }
            }
        }
    }
}
