import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Twix",
    targets: [
        .app(
            implements: .iOS,
            config: .init()
        )
    ]
)
