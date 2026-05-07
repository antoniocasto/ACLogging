# Documentation and SwiftUI Tests Plan

- [x] Start from `develop` and create a dedicated work branch.
- [x] Inventory existing documentation and tests.
- [x] Add missing SwiftUI behavior tests using Swift Testing.
- [x] Update README, CHANGELOG, public docs, and DocC for release readiness.
- [x] Run package and documentation verification.
- [x] Add explicit code-version references to every DocC page.

## Verification Notes

- `swift test --filter ScreenAppearLoggingModifier` passed after the new SwiftUI tests and internal event factory were added.
- `swift test` passed with 13 tests across 3 suites.
- `swift package dump-symbol-graph` passed.
- `xcrun docc convert` passed using generated SwiftPM symbol graphs.
- Local `xcodebuild docbuild` did not resolve the package from this shell environment; CI remains configured to run that gate on GitHub-hosted macOS.
