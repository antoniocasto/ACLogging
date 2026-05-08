# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project aims to follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.0.1] - 2026-05-08

### Fixed

- Published DocC for the verified custom domain root at `https://aclogging.acasto.dev/` without an `ACLogging` hosting base path.
- Added the GitHub Pages `CNAME` artifact and workflow checks that prevent a redirect-based root entrypoint from being published.
- Updated public release references from `1.0.0` to `1.0.1`.

## [1.0.0] - 2026-05-07

### Added

- Initial package foundation for provider-agnostic application logging.
- `ACLoggingOSLog` adapter documentation and test coverage for deterministic formatting helpers.
- SwiftUI screen lifecycle logging documentation for `ACLoggingSwiftUI`.
- Typed `LoggableEvent` usage, `LogParameters`/`LogValue`, event naming, async flow conventions, and test support documentation.
- iOS SwiftUI catalog app under `Examples/ACLoggingCatalog` for testing ACLogging before SPM adoption.
- Versioning and release policy documentation for Semantic Versioning, GitHub tags, changelog entries, and roadmap planning.
- SPM package compliance documentation, DocC catalog, and roadmap.
- Public logo asset and usage-focused DocC articles for typed events, OSLog, SwiftUI screen tracking, and testing.
- `LogOptions` and `LogParameterPrivacy` for per-event log type and parameter privacy handling.
- `LogIdentityService` and `LogSubject` for optional identity handling outside the core event service contract.
- Automated `ACLoggingSwiftUI` tests for screen lifecycle event construction.

### Changed

- Release tag policy uses `X.Y.Z` tags without a leading `v`.
- `LoggableEvent` now exposes `options` instead of a direct `logType` property.
- `OSLogService` now applies parameter privacy per event instead of using a service-wide parameter printing flag.
