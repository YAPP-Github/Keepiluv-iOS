import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Module.App.name,
    targets: [
        .app(
            implements: .iOS,
            config: .init(
                settings: .settings(
                    base: [
                        "CODE_SIGN_STYLE": "Manual",
                        "DEVELOPMENT_TEAM": "VZC79KP79S",
                        "PROVISIONING_PROFILE_SPECIFIER": "match Development org.yapp.twix"
                    ]
                )
            )
        )
    ]
)
