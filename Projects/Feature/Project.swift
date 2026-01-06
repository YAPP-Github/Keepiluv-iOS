import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name,
    targets: [
        .feature(
            config: .init(
                sources: .sources,
                dependencies: [
                    .domain
                ] + Module.Feature.allCases.map { .feature(implements: $0) }
            )
        )
    ]
)
