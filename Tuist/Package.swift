// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "ComposableArchitecture": .framework,
            "Kingfisher": .staticLibrary,
            "Pulse": .framework,
            "KakaoSDK": .staticLibrary,
            "GoogleSignIn": .staticLibrary,
            "GoogleSignInSwift": .staticLibrary,
        ]
    )
#endif

let package = Package(
    name: "Twix",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.23.1"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.0.0"),
        .package(url: "https://github.com/kean/Pulse", from: "5.1.4"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.27.1"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "9.1.0")
    ]
)
