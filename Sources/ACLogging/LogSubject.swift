/// An identity-like subject associated with subsequent log activity.
///
/// A subject can represent a user, account, organization, tenant, device, or any
/// app-defined entity that a logging destination can associate with events.
public struct LogSubject: Sendable, Equatable {
    /// A stable identifier for the subject when one is available.
    public let id: String?

    /// The app-defined subject category, such as `user`, `account`, or `tenant`.
    public let kind: String?

    /// Additional typed properties that describe the subject.
    public let properties: LogParameters

    /// Creates an identity subject.
    ///
    /// - Parameters:
    ///   - id: A stable identifier for the subject when one is available.
    ///   - kind: The app-defined subject category.
    ///   - properties: Additional typed properties that describe the subject.
    public init(
        id: String? = nil,
        kind: String? = nil,
        properties: LogParameters = [:]
    ) {
        self.id = id
        self.kind = kind
        self.properties = properties
    }
}
