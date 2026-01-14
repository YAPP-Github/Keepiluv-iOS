import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name,
    targets: [
        .feature(
            config: .init(
                sources: .sources,
                dependencies: [
                    ] + Module.Domain.allCases.map { .domain(interface: $0) } + [
                    .core(implements: .logging),
                    .core(implements: .network),
                    .core(interface: .network)
                ] + Module.Feature.allCases.map { .feature(interface: $0) }
            )
        )
    ]
)
