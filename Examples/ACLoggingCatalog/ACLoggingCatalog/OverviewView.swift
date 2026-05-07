import SwiftUI

struct OverviewView: View {
    let store: CatalogLogStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    CatalogSection(
                        "ACLogging Catalog",
                        subtitle: "A local iOS app for testing the package before adding it to another project."
                    ) {
                        HStack {
                            metric("Products", value: "4")
                            metric("Active services", value: "2")
                            metric("Captured calls", value: "\(store.entries.count)")
                        }
                    }

                    CatalogSection("Products") {
                        product("ACLogging", "Core provider-neutral logging surface.")
                        product("ACLoggingOSLog", "Unified logging adapter for local development.")
                        product("ACLoggingSwiftUI", "Screen lifecycle logging through SwiftUI modifiers.")
                        product("ACLoggingTestSupport", "Mock service utilities for package consumers' tests.")
                    }

                    CatalogSection("SPM Recipe") {
                        Text("""
                        .package(url: "https://github.com/antoniocasto/ACLogging.git", from: "1.0.0")
                        """)
                        .font(.caption.monospaced())
                        .textSelection(.enabled)

                        Text("This catalog uses the same products through a local package dependency.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    if let latest = store.entries.first {
                        CatalogSection("Latest Call") {
                            Text(latest.name)
                                .font(.headline)
                            Text("\(latest.kind.rawValue) at \(latest.formattedTime)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            ParameterPreview(parameters: latest.parameters)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Overview")
        }
    }

    private func metric(_ title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title2.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func product(_ name: String, _ description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.subheadline.weight(.semibold))
            Text(description)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
