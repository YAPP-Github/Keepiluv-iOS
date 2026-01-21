import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.name + Module.Core.network.rawValue,
    targets: [
        .core(
            interface: .network,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .core(
            implements: .network,
            config: .init(
                dependencies: [
                    .core(interface: .network),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .core(
            testing: .network,
            config: .init(
                dependencies: [
                    .core(interface: .network)
                ]
            )
        ),
        .core(
            tests: .network,
            config: .init(
                dependencies: [
                    .core(testing: .network)
                ]
            )
        )
    ]
)
