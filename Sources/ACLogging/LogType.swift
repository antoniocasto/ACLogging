/// The severity or purpose of a log event.
///
/// Adapters map these provider-neutral categories to their destination's
/// severity or event types.
public enum LogType: Sendable, Equatable {
    /// Informational runtime logging.
    case info

    /// Analytics-oriented event tracking.
    case analytic

    /// Warning-level logging for recoverable problems.
    case warning

    /// Severe logging for critical failures.
    case severe
}
