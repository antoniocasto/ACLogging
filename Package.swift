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
    targets: [
        .target(
            name: "ACLogging"
        ),
        .target(
            name: "ACLoggingOSLog",
            dependencies: ["ACLogging"]
        ),
        .target(
            name: "ACLoggingSwiftUI",
            dependencies: ["ACLogging"]
        ),
        .target(
            name: "ACLoggingTestSupport",
            dependencies: ["ACLogging"]
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
        )
    ]
)
