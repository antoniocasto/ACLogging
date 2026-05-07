import ACLoggingSwiftUI
import SwiftUI

struct CatalogRootView: View {
    let store: CatalogLogStore

    var body: some View {
        TabView {
            OverviewView(store: store)
                .tabItem { Label("Overview", systemImage: "square.grid.2x2") }

            EventScenariosView(store: store)
                .tabItem { Label("Events", systemImage: "bolt") }

            IdentitySubjectView(store: store)
                .tabItem { Label("Identity", systemImage: "person.crop.circle") }

            ScreenLifecycleDemoView(store: store)
                .tabItem { Label("SwiftUI", systemImage: "rectangle.on.rectangle") }

            AdaptersView(store: store)
                .tabItem { Label("Adapters", systemImage: "point.3.connected.trianglepath.dotted") }

            ConsoleView(store: store)
                .tabItem { Label("Console", systemImage: "list.bullet.rectangle") }
        }
        .logManager(store.logManager)
    }
}
