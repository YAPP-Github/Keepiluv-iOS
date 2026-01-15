import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.name + Module.Core.logging.rawValue,
    targets: [
        .core(
            interface: .logging,
            config: .init(
                dependencies: [
                    .external(dependency: .Pulse)
                ]
            )
        ),
        .core(
            implements: .logging,
            config: .init(
                dependencies: [
                    .core(interface: .logging),
                    .core(interface: .network),
                    .external(dependency: .Pulse),
                    .external(dependency: .PulseUI)
                ]
            )
        ),
        .core(
            testing: .logging,
            config: .init(
                dependencies: [
                    .core(interface: .logging)
                ]
            )
        ),
        .core(
            tests: .logging,
            config: .init(
                dependencies: [
                    .core(testing: .logging)
                ]
            )
        )
    ]
)
