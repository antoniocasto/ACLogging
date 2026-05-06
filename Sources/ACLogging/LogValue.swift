import Foundation

/// A type-safe value that can be attached to log events and user properties.
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
    case date(Date)
}
