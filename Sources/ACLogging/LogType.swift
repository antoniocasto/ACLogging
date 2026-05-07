/// The severity or purpose of a log event.
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
