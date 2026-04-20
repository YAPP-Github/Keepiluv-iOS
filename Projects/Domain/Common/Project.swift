import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Domain.name + Module.Domain.common.rawValue,
    targets: [
        .domain(
            interface: .common,
            config: .init()
        ),
        .domain(
            implements: .common,
            config: .init(
                dependencies: [
                    .domain(interface: .common)
                ]
            )
        )
    ]
)
