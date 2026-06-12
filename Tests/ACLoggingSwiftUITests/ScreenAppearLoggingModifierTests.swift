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

    @MainActor
    @Test("configured event names override lifecycle defaults")
    func configuredEventNamesOverrideLifecycleDefaults() {
        let modifier = ScreenAppearLoggingModifier(
            configuration: ScreenLoggingConfiguration(
                screenName: "Paywall",
                appearEventName: "Paywall_View_Start",
                disappearEventName: "Paywall_View_End"
            )
        )

        #expect(modifier.screenEvent(for: .appear).eventName == "Paywall_View_Start")
        #expect(modifier.screenEvent(for: .disappear).eventName == "Paywall_View_End")
    }

    @MainActor
    @Test("configured parameters and options apply to lifecycle events")
    func configuredParametersAndOptionsApplyToLifecycleEvents() {
        let parameters: LogParameters = [
            "source": .string("catalog"),
            "position": .int(2)
        ]
        let options = LogOptions(logType: .warning, parameterPrivacy: .public)
        let modifier = ScreenAppearLoggingModifier(
            configuration: ScreenLoggingConfiguration(
                screenName: "Paywall",
                parameters: parameters,
                options: options
            )
        )

        let appearEvent = modifier.screenEvent(for: .appear)
        let disappearEvent = modifier.screenEvent(for: .disappear)

        #expect(appearEvent.parameters == parameters)
        #expect(appearEvent.options == options)
        #expect(disappearEvent.parameters == parameters)
        #expect(disappearEvent.options == options)
    }

    @MainActor
    @Test("name initializer delegates to default configuration")
    func nameInitializerDelegatesToDefaultConfiguration() {
        let modifier = ScreenAppearLoggingModifier(name: "Home")

        let appearEvent = modifier.screenEvent(for: .appear)

        #expect(appearEvent == AnyLoggableEvent(
            eventName: "Home_appear",
            parameters: nil,
            options: LogOptions()
        ))
    }

    @MainActor
    @Test("default configuration builds lifecycle event names")
    func defaultConfigurationBuildsLifecycleEventNames() {
        let modifier = ScreenAppearLoggingModifier(
            configuration: ScreenLoggingConfiguration(screenName: "Settings")
        )

        #expect(modifier.screenEvent(for: .appear).eventName == "Settings_appear")
        #expect(modifier.screenEvent(for: .disappear).eventName == "Settings_disappear")
    }
}
