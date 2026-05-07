/// A destination capability for associating logs with an identity-like subject.
public protocol LogIdentityService: Sendable {
    /// Sets or updates the current identity subject.
    func identify(_ subject: LogSubject)

    /// Clears the current identity subject.
    func clearIdentity()
}
