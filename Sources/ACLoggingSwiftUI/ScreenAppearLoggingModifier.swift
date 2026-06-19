import ACLogging
#if canImport(SkipFuseUI)
import SkipFuseUI
#endif
import SwiftUI

enum ScreenLifecyclePhase {
    case appear
    case disappear

    var suffix: String {
        switch self {
        case .appear:
            return "appear"
        case .disappear:
            return "disappear"
        }
    }
}

/// Configuration for SwiftUI screen lifecycle logging.
public struct ScreenLoggingConfiguration: Sendable, Equatable {
    /// The stable screen name used for default lifecycle event names.
    public let screenName: String

    /// The explicit event name emitted when the view appears.
    public let appearEventName: String?

    /// The explicit event name emitted when the view disappears.
    public let disappearEventName: String?

    /// Static parameters attached to each lifecycle event.
    public let parameters: LogParameters?

    /// Options attached to each lifecycle event.
    public let options: LogOptions

    /// Creates a screen lifecycle logging configuration.
    public init(
        screenName: String,
        appearEventName: String? = nil,
        disappearEventName: String? = nil,
        parameters: LogParameters? = nil,
        options: LogOptions = LogOptions()
    ) {
        self.screenName = screenName
        self.appearEventName = appearEventName
        self.disappearEventName = disappearEventName
        self.parameters = parameters
        self.options = options
    }

    func eventName(for phase: ScreenLifecyclePhase) -> String {
        switch phase {
        case .appear:
            return appearEventName ?? "\(screenName)_\(phase.suffix)"
        case .disappear:
            return disappearEventName ?? "\(screenName)_\(phase.suffix)"
        }
    }
}

struct ACLoggingLogManagerKey: EnvironmentKey {
    static let defaultValue: LogManager? = nil
}

extension EnvironmentValues {
    var acLoggingLogManager: LogManager? {
        get { self[ACLoggingLogManagerKey.self] }
        set { self[ACLoggingLogManagerKey.self] = newValue }
    }
}

/// A SwiftUI modifier that logs screen appear and disappear lifecycle events.
public struct ScreenAppearLoggingModifier: ViewModifier {
    @Environment(\.acLoggingLogManager) var logManager

    let configuration: ScreenLoggingConfiguration

    /// Creates a screen lifecycle logging modifier.
    ///
    /// - Parameter name: The screen name used as the event prefix.
    public init(name: String) {
        self.init(configuration: ScreenLoggingConfiguration(screenName: name))
    }

    /// Creates a screen lifecycle logging modifier.
    ///
    /// - Parameter configuration: The screen lifecycle logging configuration.
    public init(configuration: ScreenLoggingConfiguration) {
        self.configuration = configuration
    }

    /// Builds the modified view body.
    public func body(content: Content) -> some View {
        content
            .onAppear {
                trackScreenEvent(for: .appear)
            }
            .onDisappear {
                trackScreenEvent(for: .disappear)
            }
    }

    func screenEvent(for phase: ScreenLifecyclePhase) -> AnyLoggableEvent {
        AnyLoggableEvent(
            eventName: configuration.eventName(for: phase),
            parameters: configuration.parameters,
            options: configuration.options
        )
    }

    private func trackScreenEvent(for phase: ScreenLifecyclePhase) {
        logManager?.trackScreenEvent(screenEvent(for: phase))
    }
}

public extension View {
    /// Injects the log manager used by ACLogging SwiftUI modifiers.
    // SKIP @nobridge
    func logManager(_ logManager: LogManager?) -> some View {
        environment(\.acLoggingLogManager, logManager)
    }

    /// Logs `<name>_appear` and `<name>_disappear` when the view appears and disappears.
    // SKIP @nobridge
    func screenLogging(name: String) -> some View {
        modifier(ScreenAppearLoggingModifier(name: name))
    }

    /// Logs configured screen lifecycle events when the view appears and disappears.
    // SKIP @nobridge
    func screenLogging(_ configuration: ScreenLoggingConfiguration) -> some View {
        modifier(ScreenAppearLoggingModifier(configuration: configuration))
    }
}
