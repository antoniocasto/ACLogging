# ROADMAP

## Goal

Grow ACLogging from a compact `1.0.0`-ready Swift logging package into a broader `2.0.0` logging foundation while keeping the core provider-agnostic, dependency-free, testable, and predictable for iOS and macOS apps.

## Locked Decisions

- The core `ACLogging` product must not depend on provider SDKs, `OSLog`, SwiftUI, or app-specific delivery infrastructure.
- Adapter products own platform and provider-specific behavior.
- Public event metadata uses `LogParameters` and `LogValue`, not `[String: Any]`.
- `LogManager` stays focused on fan-out to configured `LogService` implementations.
- Delivery, formatting, retry, batching, persistence, and SDK conversion remain adapter responsibilities unless a future major version deliberately changes that contract.
- Release tags use plain Semantic Versioning such as `1.0.0`, without a leading `v`.

## 1.0.0 Baseline

### Ready Scope

- `ACLogging`: dependency-free core types for manager fan-out, services, typed events, event values, and log type classification.
- `ACLoggingOSLog`: Apple unified logging adapter with deterministic parameter formatting and configurable parameter printing.
- `ACLoggingSwiftUI`: SwiftUI screen lifecycle tracking through environment-injected `LogManager`.
- `ACLoggingTestSupport`: `MockLogService` for deterministic assertions without provider SDKs or network calls.
- Public documentation: README, DocC articles, adapter guide, event conventions, versioning policy, changelog, and example catalog app.
- Verification: package tests cover core forwarding, `LogValue` Codable round trips, OSLog formatting, and SwiftUI lifecycle event construction.

### Useful Signals For 1.x Planning

- The catalog app already exposes future adapter slots for Firebase, Mixpanel, and custom providers.
- Current SwiftUI tracking is intentionally minimal: `appear` and `disappear` events with no custom names or parameters.
- `LogValue` covers the common scalar payload types but not richer provider payload shapes such as arrays, nested objects, URLs, decimals, or explicit null values.
- OSLog privacy is currently controlled through `shouldPrintParameters`, while finer per-parameter privacy policy is not modeled.
- The package has a clean adapter boundary, but no formal adapter authoring kit, provider compliance checklist, or migration templates yet.

## Release Policy

- Patch releases contain compatibility fixes, documentation corrections, CI updates, and non-breaking adapter hardening.
- Minor releases add backward-compatible capabilities, optional products, docs, tests, examples, or adapter packages.
- Breaking API cleanup after `1.0.0` is reserved for `2.0.0` and must include migration guidance.
- `CHANGELOG.md` remains the source of truth for released changes; this roadmap describes planned direction only.

## Suggested Release Sequence

## 1.0.0 - Stable Baseline

- Publish the stable core, OSLog adapter, SwiftUI lifecycle helper, test support, documentation, catalog app, CI, and DocC site.
- Treat the current public API surface as source-stable for the 1.x line.
- Confirm hosted DocC URL and update public documentation links after the first successful `main` deployment.

## 1.0.x - Stabilization And Adoption Feedback

- Fix documentation issues found during first external installation and catalog usage.
- Harden CI and DocC workflows around the final public repository settings.
- Add migration notes from pre-1.0 package references to `1.0.0`.
- Capture feedback from at least one production integration before expanding the API surface.

## 1.1.0 - SwiftUI Ergonomics

- Add additive SwiftUI screen tracking configuration where the current fixed `<Screen>_appear` and `<Screen>_disappear` naming is too narrow.
- Consider custom appear/disappear event names, static parameters, log type override, and a clearer no-manager behavior contract.
- Extend DocC and catalog scenarios to show recommended SwiftUI navigation and tab integration patterns.

**Needs deeper review:**
- Decide whether screen tracking should stay lifecycle-based only or include higher-level navigation semantics.
- Validate naming and parameter customization against real app analytics conventions before committing to public API.

## 1.2.0 - Adapter Authoring Kit

- Document a first-class adapter implementation checklist for third-party and private app teams.
- Add reusable test support patterns for adapter conformance, parameter conversion, call ordering, and failure behavior.
- Clarify how adapters should handle unsupported `LogValue` cases, provider limits, user identity, and deletion requests.
- Expand the catalog app with a custom adapter template flow.

**Needs deeper review:**
- Compare Firebase Analytics, Mixpanel, and at least one custom/internal analytics provider to avoid adapter guidance that only fits OSLog.
- Decide whether adapter conformance tests should be shipped as public test helpers or only documented examples.

## 1.3.0 - Privacy And Parameter Policy

- Introduce additive documentation and helper APIs for privacy-safe parameter handling.
- Explore per-parameter redaction, allowlists, event review checklists, and safer OSLog parameter visibility defaults.
- Add examples for separating analytics payloads from diagnostics payloads.

**Needs deeper review:**
- Validate privacy terminology and defaults against Apple unified logging behavior and common analytics SDK expectations.
- Decide whether privacy metadata belongs in `LogValue`, `LogParameters`, a wrapper type, or adapter-local configuration.

## 1.4.0 - Provider Adapter Incubation

- Prototype one remote analytics adapter behind a separate product or package, with Firebase Analytics and Mixpanel as the primary candidates.
- Keep provider SDK dependencies out of `ACLogging`.
- Use the prototype to validate `LogValue` conversion, user identity mapping, screen event mapping, and delete-profile behavior.
- Document why each adapter belongs in this repository, a sibling package, or a downstream app package.

**Needs deeper review:**
- Check current provider SDK APIs, minimum platform support, SPM dependency behavior, privacy requirements, and event/property limits before choosing the first official adapter.
- Decide whether official adapters should be versioned with the core package or released independently.

## 1.5.0 - Event Schema Governance

- Add high-level conventions for event catalogs, ownership, naming review, deprecation, and dashboard-safe evolution.
- Explore lightweight validation tools or test helpers that can assert event names, required parameters, and value types.
- Extend the catalog app or docs with an event inventory example that app teams can adapt.

**Needs deeper review:**
- Determine whether schema validation should remain documentation-only, live in `ACLoggingTestSupport`, or become a separate developer-tool product.
- Validate the event inventory format against real team workflows before committing to a generated format.

## 1.6.0 - Reliability And Observability Patterns

- Document recommended adapter-level patterns for queueing, batching, retry, persistence, offline handling, and failure reporting.
- Add examples showing how an adapter can expose internal diagnostics without changing the core `LogService` contract.
- Consider additive hooks for debug builds or catalog visualization if they do not weaken the provider-agnostic boundary.

**Needs deeper review:**
- Profile whether synchronous fan-out through multiple services is still acceptable for common app flows.
- Decide whether any async or backpressure behavior belongs in the core before deferring it to `2.0.0`.

## 1.7.0 - Platform And Tooling Expansion

- Broaden verification across supported iOS and macOS floors, current Xcode versions, and documentation publishing paths.
- Add richer catalog flows for identity, user properties, screen lifecycle, adapter previews, and failure scenarios.
- Improve public release checklists for tags, GitHub releases, DocC archives, and migration notes.

**Needs deeper review:**
- Decide whether macOS deserves a dedicated example target or whether Swift Package tests and docs are enough.
- Confirm the support window for future Swift tools and platform version bumps before any breaking release.

## 2.0.0 - Major API Review

- Use the 1.x adoption record to make deliberate breaking changes only where the stable API blocked real integrations.
- Potential review areas include `LogService` method shape, async delivery contracts, richer `LogValue` modeling, privacy metadata, screen tracking semantics, adapter package topology, and test-support API names.
- Publish a migration guide from `1.x` to `2.0.0` with source examples for core usage, SwiftUI usage, OSLog configuration, and adapter implementations.
- Keep the major release focused on contract cleanup rather than broad feature expansion.

**Needs deeper review:**
- Collect concrete migration pain from production adopters before approving any breaking change.
- Validate whether async APIs, richer payload types, or privacy metadata are worth a major-version migration cost.
- Decide the long-term package topology for official provider adapters before changing product names or dependency boundaries.

## Open Research Backlog

- Production adoption review: gather real event models, screen tracking needs, provider mixes, and test expectations from at least one app.
- Provider SDK review: compare Firebase Analytics, Mixpanel, and custom provider APIs for payload limits, reserved keys, identity semantics, deletion behavior, and SPM friction.
- Privacy review: define how ACLogging documentation should discuss PII, OSLog visibility, analytics consent, and redaction without pretending to own app policy.
- Performance review: measure synchronous multi-service fan-out in representative app flows before proposing async or queueing changes.
- Payload model review: decide whether `LogValue` should grow to support arrays, nested objects, decimal values, URLs, nulls, or provider-specific escape hatches.
- SwiftUI semantics review: decide whether lifecycle events are enough or whether navigation, tab, sheet, and scene transitions need a higher-level model.
