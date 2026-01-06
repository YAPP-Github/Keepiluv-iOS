import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Shared.name + Module.Shared.thirdPartyLib.rawValue,
    targets: [
        .shared(
            implements: .thirdPartyLib,
            config: .init(
                dependencies: [
                    .SPM.composableArchitecture
                ]
            )
        )
    ]
)
