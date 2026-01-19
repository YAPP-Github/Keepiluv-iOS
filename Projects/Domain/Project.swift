import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Domain.name,
    targets: [
        .domain(
            config: .init(
                sources: .sources,
                dependencies: [
                    .core
                ] + Module.Domain.allCases.map { .domain(implements: $0) }
            )
        )
    ]
)
