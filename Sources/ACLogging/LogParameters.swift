/// A type-safe collection of event or user property values.
///
/// Keys should be stable, non-sensitive identifiers owned by the consuming app.
/// Values may still contain sensitive data, so privacy review remains the
/// responsibility of the app and adapter.
public typealias LogParameters = [String: LogValue]
