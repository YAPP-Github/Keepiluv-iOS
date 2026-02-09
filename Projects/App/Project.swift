import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - 공통 설정

private let commonInfoPlist: [String: Plist.Value] = Project.Environment.InfoPlist.launchScreen.merging([
    "CFBundleDisplayName": "Keepiluv",
    "UIUserInterfaceStyle": "Light",
    "LSApplicationQueriesSchemes": [
        "kakaokompassauth",
        "kakaolink",
        "kakaotalk"
    ],
    "CFBundleURLTypes": [
        [
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": ["kakao$(KAKAO_APP_KEY)"]
        ],
        [
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": ["$(GOOGLE_REVERSED_CLIENT_ID)"]
        ]
    ],
    "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
    "GIDClientID": "$(GOOGLE_CLIENT_ID)",
    "DEEPLINK_HOST": "$(DEEPLINK_HOST)",
    "API_BASE_URL": "$(API_BASE_URL)",
    "NSCameraUsageDescription": "UseCamera"
], uniquingKeysWith: { current, _ in current })

private let commonDependencies: [TargetDependency] = [
    .feature,
    .core,
    .domain(implements: .auth),
    .external(dependency: .KakaoSDKAuth),
    .external(dependency: .KakaoSDKCommon),
    .external(dependency: .GoogleSignIn)
]

private let commonBuildSettings: SettingsDictionary = [
    "CODE_SIGN_ALLOW_ENTITLEMENTS_MODIFICATION": "YES",
    "CODE_SIGN_STYLE": "Manual",
    "DEVELOPMENT_TEAM": "\(Project.Environment.BundleId.teamId)",
    "TARGETED_DEVICE_FAMILY": "1",
    "SUPPORTS_MACCATALYST": "NO",
    "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO",
    "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
    "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"],
    "KAKAO_APP_KEY": "d62cbf5d1d7fbc9246c0d33998fce8cd",
    "GOOGLE_CLIENT_ID": "48737424560-adiebqu29lsflj85v9vrd4e4a3cp6sa3.apps.googleusercontent.com",
    "GOOGLE_REVERSED_CLIENT_ID": "com.googleusercontent.apps.48737424560-adiebqu29lsflj85v9vrd4e4a3cp6sa3",
    "DEEPLINK_HOST": "keepiluv.jiyong.xyz",
    "API_BASE_URL": "https://api.dev.teamtwix.com"
]

// MARK: - Project

let project = Project(
    name: Module.App.name,
    targets: [
        // Release용 타겟 - Pulse 없음
        .app(
            implements: .iOS,
            config: .init(
                infoPlist: .extendingDefault(with: commonInfoPlist),
                entitlements: .file(path: "Support/Twix.entitlements"),
                scripts: [.swiftLint],
                dependencies: commonDependencies,
                settings: .settings(
                    base: commonBuildSettings.merging([
                        "PROVISIONING_PROFILE_SPECIFIER": "match Development \(Project.Environment.BundleId.bundlePrefix)"
                    ])
                )
            )
        ),

        // Debug용 타겟 - Pulse 포함
        .makeTarget(
            config: .init(
                name: "TwixDebug",
                destinations: .iOS,
                product: .app,
                bundleId: Project.Environment.BundleId.bundlePrefix,
                infoPlist: .extendingDefault(with: commonInfoPlist),
                sources: "Sources/**",
                resources: ["Resources/**"],
                entitlements: .file(path: "Support/Twix.entitlements"),
                scripts: [.swiftLint],
                dependencies: commonDependencies + [
                    .coreLoggingDebug
                ],
                settings: .settings(
                    base: commonBuildSettings.merging([
                        "PROVISIONING_PROFILE_SPECIFIER": "match Development \(Project.Environment.BundleId.bundlePrefix)",
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG"
                    ])
                )
            )
        )
    ],
    schemes: [
        .scheme(
            name: "Twix",
            buildAction: .buildAction(targets: [.target("Twix")]),
            runAction: .runAction(configuration: "Release"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
        .scheme(
            name: "TwixDebug",
            buildAction: .buildAction(targets: [.target("TwixDebug")]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Debug")
        )
    ]
)
