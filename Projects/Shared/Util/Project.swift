import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Shared.name + Module.Shared.util.rawValue,
    targets: [
        .shared(
            implements: .util,
            config: .init(
                resources: ["Resources/**"]
            )
        )
    ]
)