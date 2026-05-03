import ACLoggingSwiftUI
import SwiftUI

struct ScreenLifecycleDemoView: View {
    let store: CatalogLogStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Open tracked paywall screen") {
                        TrackedScreen(name: "CatalogPaywall")
                    }

                    NavigationLink("Open no-op screen without injected manager") {
                        TrackedScreen(name: "NoManagerDemo")
                            .logManager(nil)
                    }
                } footer: {
                    Text("Opening and closing these screens demonstrates appear and disappear events.")
                }
            }
            .navigationTitle("SwiftUI")
        }
    }
}

private struct TrackedScreen: View {
    let name: String

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "rectangle.on.rectangle")
                .font(.system(size: 44))
                .foregroundStyle(.blue)
            Text(name)
                .font(.title2.bold())
            Text("This view applies screenLogging(name:) and emits lifecycle events through the injected LogManager.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle(name)
        .screenLogging(name: name)
    }
}
