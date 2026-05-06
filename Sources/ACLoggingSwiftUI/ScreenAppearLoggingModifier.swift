import ACLogging
import SwiftUI

private struct ACLoggingLogManagerKey: EnvironmentKey {
    static let defaultValue: LogManager? = nil
}

private extension EnvironmentValues {
    var acLoggingLogManager: LogManager? {
        get { self[ACLoggingLogManagerKey.self] }
        set { self[ACLoggingLogManagerKey.self] = newValue }
    }
}

/// A SwiftUI modifier that logs screen appear and disappear lifecycle events.
public struct ScreenAppearLoggingModifier: ViewModifier {
    @Environment(\.acLoggingLogManager) private var logManager

    private let name: String

    /// Creates a screen lifecycle logging modifier.
    ///
    /// - Parameter name: The screen name used as the event prefix.
    public init(name: String) {
        self.name = name
    }

    /// Builds the modified view body.
    public func body(content: Content) -> some View {
        content
            .onAppear {
                trackScreenEvent(suffix: "appear")
            }
            .onDisappear {
                trackScreenEvent(suffix: "disappear")
            }
    }

    private func trackScreenEvent(suffix: String) {
        let event = AnyLoggableEvent(
            eventName: "\(name)_\(suffix)",
            parameters: nil,
            logType: .analytic
        )
        logManager?.trackScreenEvent(event)
    }
}

public extension View {
    /// Injects the log manager used by ACLogging SwiftUI modifiers.
    func logManager(_ logManager: LogManager?) -> some View {
        environment(\.acLoggingLogManager, logManager)
    }

    /// Logs `<name>_appear` and `<name>_disappear` when the view appears and disappears.
    func screenLogging(name: String) -> some View {
        modifier(ScreenAppearLoggingModifier(name: name))
    }
}
