# ``ACLogging``

Build provider-agnostic application logging for Swift and Skip Fuse apps.

## Overview

`ACLogging` gives application code a small, provider-neutral logging surface. Feature modules send typed or ad-hoc events to ``LogManager`` while concrete ``LogService`` implementations decide where those events go.

The core product defines event names, strongly typed ``LogParameters``, ``LogValue`` payloads, event categories through ``LogType``, and privacy intent through ``LogOptions``. Optional products add ready-made integrations for Apple's unified logging system, SwiftUI screen lifecycle tracking, and test doubles.

The package is configured for Skip Fuse native mode. Source targets include `Skip/skip.yml`, use the `skipstone` plugin, and keep bridging enabled for public APIs so the same package can be used from traditional iOS apps and Skip Fuse apps.

Identity support is intentionally separate from event delivery. Services that can associate events with a subject conform to ``LogIdentityService``; destinations that do not support identity can remain simple ``LogService`` implementations.

## Package Version

The current stable public package release is `1.1.1`.

## Choose A Product

- `ACLogging`: Use in shared domain, feature, and infrastructure modules to model events without coupling them to a provider SDK.
- `ACLoggingOSLog`: Use when events should be written through `OSLogService` on Apple platforms or Skip Fuse.
- `ACLoggingSwiftUI`: Use when SwiftUI or Skip Fuse UI views should emit simple `<screen>_appear` and `<screen>_disappear` lifecycle events.
- `ACLoggingTestSupport`: Use in tests to assert forwarded events and identity calls without sending data to a real destination.

## Ownership Boundaries

- `ACLogging` owns the provider-neutral logging surface and event value model.
- Adapter products own provider-specific formatting, delivery, retry, persistence, and SDK conversion.
- The consuming app owns event naming, business semantics, privacy review, and adapter selection.
- ``LogOptions`` records the event category and parameter privacy intent, but each adapter owns the final rendering behavior for its destination.

## Topics

### Essentials

- ``LogManager``
- ``LogService``
- ``LogIdentityService``
- ``LogSubject``

### Events

- ``LoggableEvent``
- ``AnyLoggableEvent``
- ``LogParameters``
- ``LogValue``
- ``LogType``
- ``LogOptions``
- ``LogParameterPrivacy``

### Integration Guides

- <doc:IntegrationBoundaries>
- <doc:TypedEventExamples>

### Adapter Guides

- <doc:OSLogAdapterExamples>
- <doc:SwiftUIScreenTrackingExamples>

### Testing

- <doc:TestingExamples>
