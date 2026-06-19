// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ACLogging",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ACLogging",
            targets: ["ACLogging"]
        ),
        .library(
            name: "ACLoggingOSLog",
            targets: ["ACLoggingOSLog"]
        ),
        .library(
            name: "ACLoggingSwiftUI",
            targets: ["ACLoggingSwiftUI"]
        ),
        .library(
            name: "ACLoggingTestSupport",
            targets: ["ACLoggingTestSupport"]
        )
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.7.0"),
        .package(url: "https://source.skip.tools/skip-fuse.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "ACLogging",
            dependencies: [
                .product(name: "SkipFuse", package: "skip-fuse")
            ],
            plugins: [
                .plugin(name: "skipstone", package: "skip")
            ]
        ),
        .target(
            name: "ACLoggingOSLog",
            dependencies: [
                "ACLogging",
                .product(name: "SkipFuse", package: "skip-fuse")
            ],
            plugins: [
                .plugin(name: "skipstone", package: "skip")
            ]
        ),
        .target(
            name: "ACLoggingSwiftUI",
            dependencies: [
                "ACLogging",
                .product(name: "SkipFuseUI", package: "skip-fuse-ui", condition: .when(platforms: [.android]))
            ],
            plugins: [
                .plugin(name: "skipstone", package: "skip")
            ]
        ),
        .target(
            name: "ACLoggingTestSupport",
            dependencies: [
                "ACLogging",
                .product(name: "SkipFuse", package: "skip-fuse")
            ],
            plugins: [
                .plugin(name: "skipstone", package: "skip")
            ]
        ),
        .testTarget(
            name: "ACLoggingTests",
            dependencies: [
                "ACLogging",
                "ACLoggingTestSupport"
            ]
        ),
        .testTarget(
            name: "ACLoggingOSLogTests",
            dependencies: [
                "ACLogging",
                "ACLoggingOSLog"
            ]
        ),
        .testTarget(
            name: "ACLoggingSwiftUITests",
            dependencies: [
                "ACLogging",
                "ACLoggingSwiftUI"
            ]
        )
    ]
)
