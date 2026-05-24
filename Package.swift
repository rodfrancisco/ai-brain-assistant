// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AIBrainAssistant",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/sindresorhus/KeyboardShortcuts", from: "1.14.0"),
    ],
    targets: [
        .executableTarget(
            name: "AIBrainAssistant",
            dependencies: [
                "KeyboardShortcuts"
            ]
        ),
        .testTarget(
            name: "AIBrainAssistantTests",
            dependencies: ["AIBrainAssistant"]
        ),
    ]
)
