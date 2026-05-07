# ``ACLogging``

Build provider-agnostic application logging for Swift apps.

## Code Reference

This documentation describes the unreleased ACLogging API planned for `0.1.0`. After a public release is tagged, use the DocC documentation generated from the matching Git tag for that package version.

## Overview

`ACLogging` is a Swift Package centered on ``LogManager``, ``LogService``, ``LoggableEvent``, ``LogParameters``, and ``LogValue``. It keeps feature code independent from analytics or logging vendors while adapter products handle delivery to concrete destinations.

## Package Version

The currently planned public package release is `0.1.0`. No public release tag has been cut yet.

`1.0.0` is reserved for the stable API milestone after production adoption and a documented migration review.

## Ownership Boundaries

- `ACLogging` owns the provider-neutral logging surface and event value model.
- Adapter products own provider-specific formatting, delivery, retry, persistence, and SDK conversion.
- The consuming app owns event naming, business semantics, privacy review, and adapter selection.

## Verification

The package is verified with Swift Testing suites for core forwarding, typed values, OSLog formatting, and SwiftUI screen lifecycle event construction. CI also validates package build and DocC generation for pull requests targeting `develop` and `main`.

## Topics

### Essentials

- ``LogManager``
- ``LogService``
- ``LoggableEvent``
- ``AnyLoggableEvent``

### Event Values

- ``LogParameters``
- ``LogValue``
- ``LogType``

### Articles

- <doc:IntegrationBoundaries>
- <doc:TypedEventExamples>
- <doc:OSLogAdapterExamples>
- <doc:SwiftUIScreenTrackingExamples>
- <doc:TestingExamples>
