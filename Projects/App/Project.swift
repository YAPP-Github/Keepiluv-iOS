import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Module.App.name,
    targets: [
        .app(
            implements: .iOS,
            config: .init()
        )
    ]
)
