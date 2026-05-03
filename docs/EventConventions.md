# Event Conventions

## Naming

Use a stable event name with this shape:

```text
<Feature>_<Action>_<State>
```

Examples:

- `Paywall_View_Start`
- `Paywall_View_Success`
- `Paywall_View_Fail`
- `Settings_Save_Success`
- `Onboarding_Skip`

Use nouns for features and clear verbs for actions. Keep state names short and consistent across features.

## Async Flows

For async work, emit:

- `Start` when the operation begins.
- `Success` when the operation completes.
- `Fail` when the operation fails or is cancelled by an error state.

Use business-level feature names such as `Paywall`, `Purchase`, `Onboarding`, and `Settings` so analytics remain readable outside the implementation details.

## Parameters

Public APIs use `LogParameters`, which is a dictionary of `String` keys to `LogValue` values. Do not pass `[String: Any]`.

Supported values:

- `.string(String)`
- `.int(Int)`
- `.double(Double)`
- `.bool(Bool)`
- `.date(Date)`
