@testable import ACLoggingSwiftUI
import ACLogging
import Testing

@Suite("ScreenAppearLoggingModifier")
struct ScreenAppearLoggingModifierTests {
    @MainActor
    @Test("creates analytic appear screen event")
    func createsAnalyticAppearScreenEvent() {
        let modifier = ScreenAppearLoggingModifier(name: "Home")

        let event = modifier.screenEvent(for: .appear)

        #expect(event == AnyLoggableEvent(
            eventName: "Home_appear",
            parameters: nil,
            options: LogOptions()
        ))
    }

    @MainActor
    @Test("creates analytic disappear screen event")
    func createsAnalyticDisappearScreenEvent() {
        let modifier = ScreenAppearLoggingModifier(name: "Home")

        let event = modifier.screenEvent(for: .disappear)

        #expect(event == AnyLoggableEvent(
            eventName: "Home_disappear",
            parameters: nil,
            options: LogOptions()
        ))
    }
}
