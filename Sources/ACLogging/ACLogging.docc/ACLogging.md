# ``ACLogging``

Build provider-agnostic application logging for Swift apps.

## Overview

`ACLogging` is a Swift Package centered on ``LogManager``, ``LogService``, ``LoggableEvent``, ``LogParameters``, and ``LogValue``. It keeps feature code independent from analytics or logging vendors while adapter products handle delivery to concrete destinations. Services that support subject identity can opt into ``LogIdentityService`` without making identity handling mandatory for every logging destination.

## Package Version

The current stable public package release is `1.0.0`.

## Ownership Boundaries

- `ACLogging` owns the provider-neutral logging surface and event value model.
- Adapter products own provider-specific formatting, delivery, retry, persistence, and SDK conversion.
- The consuming app owns event naming, business semantics, privacy review, and adapter selection.

## Topics

### Essentials

- ``LogManager``
- ``LogService``
- ``LogIdentityService``
- ``LogSubject``
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
