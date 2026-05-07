# ACLogging Docs

This folder contains public documentation assets for ACLogging.

- [Event conventions](EventConventions.md)
- [Adapter guide](Adapters.md)
- [Versioning and releases](Versioning.md)
- [Roadmap](ROADMAP.md)

DocC usage articles live with the package source:

- [Typed event examples](../Sources/ACLogging/ACLogging.docc/TypedEventExamples.md)
- [OSLog adapter examples](../Sources/ACLogging/ACLogging.docc/OSLogAdapterExamples.md)
- [SwiftUI screen tracking examples](../Sources/ACLogging/ACLogging.docc/SwiftUIScreenTrackingExamples.md)
- [Testing examples](../Sources/ACLogging/ACLogging.docc/TestingExamples.md)

The core package stays dependency-free. Provider integrations belong in adapter targets so app teams can opt into only the SDKs they need.

## Release Readiness

ACLogging is being prepared for its `1.0.0` public release. The repository includes the required public package files, CI workflow, DocC workflow, roadmap, changelog, and usage-focused documentation.

## Verification

Before cutting a release, verify:

- `swift test`
- Xcode package build for the supported Apple platform floors
- DocC build through CI `xcodebuild docbuild`
- Local DocC conversion with SwiftPM symbol graphs and `xcrun docc convert`
- Changelog section for the release version
- Annotated Git tag using the plain version format, for example `1.0.0`

## Example Catalog

Open `Examples/ACLoggingCatalog/ACLoggingCatalog.xcodeproj` to run the iOS catalog app. It demonstrates the current package products and keeps adapter slots visible for future Firebase, Mixpanel, and custom provider integrations.

## Credits

This package was built while following the SwiftUI Advanced Architectures course by Nick Sarno.

YouTube: @SwiftfulThinking
Course: SwiftUI Advanced Architectures
