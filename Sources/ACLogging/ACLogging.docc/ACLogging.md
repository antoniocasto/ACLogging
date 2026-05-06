# ``ACLogging``

Build provider-agnostic application logging for Swift apps.

## Overview

`ACLogging` is a Swift Package centered on ``LogManager``, ``LogService``, ``LoggableEvent``, ``LogParameters``, and ``LogValue``. It keeps feature code independent from analytics or logging vendors while adapter products handle delivery to concrete destinations.

## Current Package Version

The currently planned public package release is `0.1.0`. No public release tag has been cut yet.

## Ownership Boundaries

- `ACLogging` owns the provider-neutral logging surface and event value model.
- Adapter products own provider-specific formatting, delivery, retry, persistence, and SDK conversion.
- The consuming app owns event naming, business semantics, privacy review, and adapter selection.

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
