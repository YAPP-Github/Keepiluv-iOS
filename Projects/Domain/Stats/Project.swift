import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Domain.name + Module.Domain.stats.rawValue,
    targets: [
        .domain(
            interface: .stats,
            config: .init(
                dependencies: [
                    .core(interface: .network),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .domain(
            implements: .stats,
            config: .init(
                dependencies: [
                    .domain(interface: .stats),
                    .core(interface: .network),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .domain(
            testing: .stats,
            config: .init(
                dependencies: [
                    .domain(interface: .stats)
                ]
            )
        ),
        .domain(
            tests: .stats,
            config: .init(
                dependencies: [
                    .domain(testing: .stats)
                ]
            )
        )
    ]
)
