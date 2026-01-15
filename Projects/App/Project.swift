import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Module.App.name,
    targets: [
        .app(
            implements: .iOS,
            config: .init(
                scripts: [.swiftLint],
                dependencies: [
                    .feature,
                    .feature(implements: .mainTab)
                ],
                settings: .settings(
                    base: [
                        "CODE_SIGN_STYLE": "Manual",
                        "DEVELOPMENT_TEAM": "\(Project.Environment.BundleId.teamId)",
                        "PROVISIONING_PROFILE_SPECIFIER": "match Development \(Project.Environment.BundleId.bundlePrefix)"
                    ]
                )
            )
        )
    ]
)
