import Foundation

/// A type-safe value that can be attached to log events and user properties.
///
/// The `Codable` conformance supports deterministic tests and local adapter
/// conversion. Do not treat the encoded representation as a cross-version
/// persistence format unless your app owns the migration policy.
public enum LogValue: Sendable, Equatable, Codable {
    /// A text value.
    case string(String)

    /// An integer value.
    case int(Int)

    /// A double-precision floating-point value.
    case double(Double)

    /// A Boolean value.
    case bool(Bool)

    /// A date value.
    ///
    /// Adapters choose the final transport representation. `OSLogService`
    /// renders dates as ISO-8601 internet date-time strings.
    case date(Date)
}
