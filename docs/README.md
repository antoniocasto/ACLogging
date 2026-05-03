# ACLogging Docs

This folder contains public documentation assets for ACLogging.

- [Event conventions](EventConventions.md)
- [Adapter guide](Adapters.md)
- [Versioning and releases](Versioning.md)

The core package stays dependency-free. Provider integrations belong in adapter targets so app teams can opt into only the SDKs they need.

## Example Catalog

Open `Examples/ACLoggingCatalog/ACLoggingCatalog.xcodeproj` to run the iOS catalog app. It demonstrates the current package products and keeps adapter slots visible for future Firebase, Mixpanel, and custom provider integrations.

## Credits

This package was built while following the SwiftUI Advanced Architectures course by Nick Sarno.

YouTube: @SwiftfulThinking
Course: SwiftUI Advanced Architectures
