// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftDemoCopilot",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftDemoCopilot",
            targets: ["SwiftDemoCopilot"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftDemoCopilot",
            dependencies: []),
        .testTarget(
            name: "SwiftDemoCopilotTests",
            dependencies: ["SwiftDemoCopilot"]),
    ]
)
