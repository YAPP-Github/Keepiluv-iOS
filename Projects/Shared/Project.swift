import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Shared.name,
    targets: [
        .shared(
            config: .init(
                sources: .sources,
                dependencies: Module.Shared.allCases.map { .shared(implements: $0) }
            )
        )
    ]
)
