import SwiftUI

@main
struct ACLoggingCatalogApp: App {
    @State private var store = CatalogLogStore()

    var body: some Scene {
        WindowGroup {
            CatalogRootView(store: store)
        }
    }
}
