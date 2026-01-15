// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "ComposableArchitecture": .framework,  // Dynamic으로 변경
            "Pulse": .framework
        ]
    )
#endif

let package = Package(
    name: "Twix",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.23.1"),
        .package(url: "https://github.com/kean/Pulse", from: "5.1.4")
    ]
)
