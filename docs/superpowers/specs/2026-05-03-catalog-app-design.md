# ACLogging Catalog App Design

## Goal

Build a true iOS SwiftUI demo app that lets developers evaluate ACLogging before importing the package through Swift Package Manager.

## Decision

The catalog will live under `Examples/ACLoggingCatalog/` as a small iOS app with its own Xcode project. The app imports the local ACLogging package products, matching the shape of a consumer app while keeping package source targets focused on reusable library code.

## Audience

The app is for developers who want to answer these questions quickly:

- Which ACLogging products exist and when should each one be used?
- What happens when I track typed events, convenience events, screen events, and user profile calls?
- How do parameters and `LogValue` values look at adapter boundaries?
- How will future provider adapters fit into the same surface?

## Screens

The app uses a `TabView` with focused screens:

- Overview: package products, active demo services, and quick start status.
- Events: typed event and convenience API scenarios for common product flows.
- User: identify user, add user properties, and delete profile actions.
- SwiftUI: a screen lifecycle demo that emits appear and disappear events through `ACLoggingSwiftUI`.
- Adapters: current OSLog support plus future slots for Firebase, Mixpanel, and custom providers.
- Console: an in-app recorder showing every call received by the demo `LogService`.

## Architecture

The catalog app owns a `CatalogLogStore` as root state. A `CatalogRecordingLogService` conforms to `LogService` and writes received calls into the store. The app also configures an `OSLogService`, so actions are visible both inside the catalog and in Apple's unified logging tools.

Scenario definitions are value types. A scenario describes its title, intent, event name, parameters, log type, and execution closure. Future adapters should add new adapter capability entries and scenario groups rather than changing the core screen structure.

## Future Version Fit

Future provider adapters should appear in the Adapters screen as capability cards with setup status and supported operations. Firebase and Mixpanel are represented now as disabled future slots so the catalog structure already communicates where those integrations belong.

The Console screen remains provider-neutral. It records calls at the ACLogging boundary, so it continues to work regardless of which concrete adapters are added later.

## Verification

The package remains verified with `swift build` and `swift test`. The catalog is verified with `xcodebuild` against an iOS simulator destination when a simulator runtime is available.

## Non-Goals

The first catalog does not include real Firebase or Mixpanel SDKs, analytics dashboards, network calls, or screenshot automation. Those belong to future adapter-specific iterations.
