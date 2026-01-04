import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.name,
    targets: [
        .core(
            config: .init(
                sources: .sources,
                dependencies: [
                    .shared
                ] + Module.Core.allCases.map { .core(implements: $0) }
            )
        )
    ]
)
