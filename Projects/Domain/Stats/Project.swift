import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Domain.name + Module.Domain.stats.rawValue,
    targets: [
        .domain(
            interface: .stats,
            config: .init()
        ),
        .domain(
            implements: .stats,
            config: .init(
                dependencies: [
                    .domain(interface: .stats)
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