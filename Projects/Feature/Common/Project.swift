import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.common.rawValue,
    targets: [
        .feature(
            interface: .common,
            config: .init(
                dependencies: [
                    .domain(interface: .common),
                    .shared(implements: .designSystem)
                ]
            )
        ),
        .feature(
            implements: .common,
            config: .init(
                dependencies: [
                    .feature(interface: .common)
                ]
            )
        )
    ]
)
