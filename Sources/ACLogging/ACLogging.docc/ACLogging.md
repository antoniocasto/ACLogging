# ``ACLogging``

Build provider-agnostic application logging for Swift apps.

## Code Reference

This documentation describes the ACLogging API released in `1.0.0`. Published DocC should be generated from the matching Git tag for the package version being documented.

## Overview

`ACLogging` is a Swift Package centered on ``LogManager``, ``LogService``, ``LoggableEvent``, ``LogParameters``, and ``LogValue``. It keeps feature code independent from analytics or logging vendors while adapter products handle delivery to concrete destinations.

## Package Version

The current stable public package release is `1.0.0`.

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
