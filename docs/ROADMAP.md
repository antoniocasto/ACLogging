# ROADMAP

## Goal

Make ACLogging a compact, provider-agnostic Swift logging package with a dependency-free core, optional adapters, test support, and clear integration documentation for iOS and macOS apps.

## Locked Decisions

- The core `ACLogging` product must not depend on provider SDKs, `OSLog`, or SwiftUI.
- Adapter products own platform and provider-specific behavior.
- Public event metadata uses `LogParameters` and `LogValue`, not `[String: Any]`.
- Release tags use plain Semantic Versioning such as `0.1.0`, without a leading `v`.
- The initial public release target is `0.1.0`.

## Architectural Contract

- `LogManager` forwards calls to configured `LogService` implementations.
- `LogService` implementations own delivery, formatting, retry, batching, and provider-specific conversion.
- `LoggableEvent` gives apps a typed event model while `AnyLoggableEvent` supports convenience construction and test assertions.
- `ACLoggingTestSupport` provides test doubles and must not be required by production targets.

## Current Assessment

### What Already Works Well

- The package has focused products for core logging, OSLog, SwiftUI lifecycle logging, and test support.
- The core target is dependency-free.
- Public symbols are small and easy to reason about.
- Swift Testing coverage exists for manager forwarding and OSLog formatting behavior.
- A local SwiftUI catalog app demonstrates supported integration flows.

### Current Gaps

- No hosted documentation URL has been published yet.
- Firebase, Mixpanel, and other remote analytics adapters are intentionally not implemented.
- SwiftUI lifecycle behavior is not covered by automated tests yet.
- There is no released `0.1.0` tag yet.

## Priorities

- Prepare and tag `0.1.0` after build, test, CI, and DocC validation pass.
- Add behavior-level tests for `ACLoggingSwiftUI`.
- Decide whether hosted docs should publish through GitHub Pages for the public repository.
- Add provider adapter packages only when their dependency and API contracts are clear.

## Release Policy

- Patch releases contain fixes, compatibility hardening, documentation corrections, and CI improvements.
- Minor releases add public capabilities or adapter products.
- Breaking API cleanup is allowed before `1.0.0` but must be called out in `CHANGELOG.md`.
- After `1.0.0`, breaking changes require a major release and migration guidance.

## Planned Design Checkpoints

- Confirm `LogValue` covers the parameter types required by initial adopters.
- Confirm whether screen lifecycle logging should support custom appear/disappear event names.
- Confirm whether remote provider adapters should live in this repository or separate packages.
- Confirm hosted docs URL before adding it to `README.md`.

## Suggested Release Sequence

## 0.1.0 - Planned

- Ship core logging, OSLog adapter, SwiftUI screen lifecycle helper, test support, README, DocC, roadmap, changelog, and CI.

## 0.2.0 - Planned

- Add automated SwiftUI lifecycle tests and any additive ergonomics discovered during early adoption.

## 1.0.0 - Planned Stable API

- Freeze the core public API after at least one production adoption cycle and documented migration review.
