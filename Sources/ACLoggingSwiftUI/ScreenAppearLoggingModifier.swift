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

public struct ScreenAppearLoggingModifier: ViewModifier {
    @Environment(\.acLoggingLogManager) private var logManager

    private let name: String

    public init(name: String) {
        self.name = name
    }

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
    func logManager(_ logManager: LogManager?) -> some View {
        environment(\.acLoggingLogManager, logManager)
    }

    func screenLogging(name: String) -> some View {
        modifier(ScreenAppearLoggingModifier(name: name))
    }
}
