# SwiftUI Screen Tracking Examples

Use `ACLoggingSwiftUI` to log simple SwiftUI appear and disappear lifecycle events.

## Inject The Manager

Inject a `LogManager` once above the views that need lifecycle logging. A scene, tab root, or feature root is usually the right scope:

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

Attach `screenLogging(name:)` to the screen root. The name is used as the event prefix:

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

The modifier sends these through `trackScreenEvent(_:)`, so adapters can separate screen lifecycle events from general events if they need different handling.

## Missing Manager Behavior

If no `LogManager` is injected, the modifier performs no logging. This allows previews and isolated views to use `screenLogging(name:)` without special setup.

## Testing Screen Logging

In tests, inject a `LogManager` backed by `MockLogService`, present the view, and assert that the expected screen event names were forwarded. Keep assertions focused on the screen event names rather than SwiftUI lifecycle timing details that the test harness owns.
