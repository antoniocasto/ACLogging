# SwiftUI Screen Tracking Examples

Use `ACLoggingSwiftUI` to log simple SwiftUI appear and disappear lifecycle events.

## Inject The Manager

Inject a `LogManager` once above the views that need lifecycle logging:

```swift
import ACLogging
import ACLoggingSwiftUI
import SwiftUI

struct AppRootView: View {
    let logManager: LogManager

    var body: some View {
        TabView {
            PaywallView()
            SettingsView()
        }
        .logManager(logManager)
    }
}
```

## Track A Screen

Attach `screenLogging(name:)` to the screen root:

```swift
struct PaywallView: View {
    var body: some View {
        VStack {
            Text("Upgrade")
            Button("Continue") {}
        }
        .screenLogging(name: "Paywall")
    }
}
```

This emits:

- `Paywall_appear`
- `Paywall_disappear`

## Missing Manager Behavior

If no `LogManager` is injected, the modifier performs no logging. This allows previews and isolated views to use `screenLogging(name:)` without special setup.
