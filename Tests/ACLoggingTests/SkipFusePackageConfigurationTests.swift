import Foundation
import Testing

@Suite("Skip Fuse package configuration")
struct SkipFusePackageConfigurationTests {
    private let packageRoot = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()

    @Test("source targets declare native Skip Fuse configuration")
    func sourceTargetsDeclareNativeSkipFuseConfiguration() throws {
        for target in ["ACLogging", "ACLoggingOSLog", "ACLoggingSwiftUI", "ACLoggingTestSupport"] {
            let skipConfiguration = try skipConfiguration(in: "Sources", target: target)

            #expect(skipConfiguration.contains("mode: 'native'"))
            #expect(skipConfiguration.contains("bridging: true"))
        }
    }

    @Test("manifest wires Skip packages and skipstone plugin")
    func manifestWiresSkipPackagesAndSkipstonePlugin() throws {
        let manifest = try String(
            contentsOf: packageRoot.appendingPathComponent("Package.swift"),
            encoding: .utf8
        )

        #expect(manifest.contains("https://source.skip.tools/skip.git"))
        #expect(manifest.contains("https://source.skip.tools/skip-fuse.git"))
        #expect(manifest.contains("https://source.skip.tools/skip-fuse-ui.git"))
        #expect(!manifest.contains("https://source.skip.tools/skip-ui.git"))
        #expect(manifest.contains(".plugin(name: \"skipstone\", package: \"skip\")"))
        #expect(manifest.contains(".product(name: \"SkipFuse\", package: \"skip-fuse\")"))
        #expect(manifest.contains(".product(name: \"SkipFuseUI\", package: \"skip-fuse-ui\", condition: .when(platforms: [.android]))"))
    }

    @Test("SwiftUI modifier remains bridgeable for Android rendering")
    func swiftUIModifierRemainsBridgeableForAndroidRendering() throws {
        let source = try String(
            contentsOf: packageRoot
                .appendingPathComponent("Sources")
                .appendingPathComponent("ACLoggingSwiftUI")
                .appendingPathComponent("ScreenAppearLoggingModifier.swift"),
            encoding: .utf8
        )

        #expect(!source.contains("// SKIP @nobridge\npublic struct ScreenAppearLoggingModifier"))
    }

    private func skipConfiguration(in directory: String, target: String) throws -> String {
        try String(
            contentsOf: packageRoot
                .appendingPathComponent(directory)
                .appendingPathComponent(target)
                .appendingPathComponent("Skip")
                .appendingPathComponent("skip.yml"),
            encoding: .utf8
        )
    }
}
