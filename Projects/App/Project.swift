import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Module.App.name,
    targets: [
        .app(
            implements: .iOS,
            config: .init(
                infoPlist: .extendingDefault(with: Project.Environment.InfoPlist.launchScreen.merging([
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
                    "GOOGLE_CLIENT_ID": "$(GOOGLE_CLIENT_ID)",
                    "GOOGLE_REVERSED_CLIENT_ID": "$(GOOGLE_REVERSED_CLIENT_ID)",
                    "DEEPLINK_HOST": "$(DEEPLINK_HOST)",
                    "API_BASE_URL": "$(API_BASE_URL)"
                ], uniquingKeysWith: { current, _ in current })),
                entitlements: .file(path: "Support/Twix.entitlements"),
                scripts: [.swiftLint],
                dependencies: [
                    .feature,
                    .core,
                    .external(dependency: .KakaoSDKAuth),
                    .external(dependency: .KakaoSDKCommon),
                    .external(dependency: .GoogleSignIn)
                ],
                settings: .settings(
                    base: [
                        "CODE_SIGN_STYLE": "Manual",
                        "DEVELOPMENT_TEAM": "\(Project.Environment.BundleId.teamId)",
                        "PROVISIONING_PROFILE_SPECIFIER": "match Development \(Project.Environment.BundleId.bundlePrefix)",
                        "TARGETED_DEVICE_FAMILY": "1",
                        "SUPPORTS_MACCATALYST": "NO",
                        "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO",
                        "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"],
                        "KAKAO_APP_KEY": "d62cbf5d1d7fbc9246c0d33998fce8cd",
                        "GOOGLE_CLIENT_ID": "48737424560-adiebqu29lsflj85v9vrd4e4a3cp6sa3.apps.googleusercontent.com",
                        "GOOGLE_REVERSED_CLIENT_ID": "com.googleusercontent.apps.48737424560-adiebqu29lsflj85v9vrd4e4a3cp6sa3",
                        "DEEPLINK_HOST": "keepiluv.jiyong.xyz",
                        "API_BASE_URL": "https://api.dev.teamtwix.com"
                    ]
                )
            )
        )
    ]
)
