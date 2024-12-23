// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ListenBrainzKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .visionOS(.v1),
        .watchOS(.v9),
    ],
    products: [
        .library(
            name: "ListenBrainzKit",
            targets: ["ListenBrainzKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0"),
    ],
    targets: [
        .target(
            name: "ListenBrainzKit",
            dependencies: [],
            path: "Sources",
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
        .testTarget(
            name: "ListenBrainzKitTests",
            dependencies: ["ListenBrainzKit"]
        ),
    ]
)
