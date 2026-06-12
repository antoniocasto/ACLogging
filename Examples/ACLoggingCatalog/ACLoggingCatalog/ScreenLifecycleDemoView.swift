import ACLogging
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

                    NavigationLink("Open configured checkout screen") {
                        ConfiguredTrackedScreen()
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

private struct ConfiguredTrackedScreen: View {
    private let configuration = ScreenLoggingConfiguration(
        screenName: "CatalogCheckout",
        appearEventName: "Checkout_View_Start",
        disappearEventName: "Checkout_View_End",
        parameters: [
            "source": .string("catalog"),
            "step": .int(2)
        ],
        options: LogOptions(logType: .analytic, parameterPrivacy: .public)
    )

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "cart")
                .font(.system(size: 44))
                .foregroundStyle(.green)
            Text("CatalogCheckout")
                .font(.title2.bold())
            Text("This view uses configured screen event names and shared parameters.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Configured")
        .screenLogging(configuration)
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
