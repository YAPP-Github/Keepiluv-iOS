import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Shared.name + Module.Shared.designSystem.rawValue,
    targets: [
        .shared(
            implements: .designSystem,
            config: .init(
                dependencies: [
                    .shared(implements: .thirdPartyLib),
                    .external(dependency: .Kingfisher)
                ]
            )
        )
    ],
    resourceSynthesizers: [
        .fonts(),
        .assets()
    ]
)
