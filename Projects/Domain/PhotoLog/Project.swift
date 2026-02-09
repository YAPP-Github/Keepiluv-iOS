import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Domain.name + Module.Domain.photoLog.rawValue,
    targets: [
        .domain(
            interface: .photoLog,
            config: .init(
                dependencies: [
                    .core(interface: .network),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .domain(
            implements: .photoLog,
            config: .init(
                dependencies: [
                    .core(interface: .network),
                    .domain(interface: .photoLog),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .domain(
            testing: .photoLog,
            config: .init(
                dependencies: [
                    .domain(interface: .photoLog)
                ]
            )
        ),
        .domain(
            tests: .photoLog,
            config: .init(
                dependencies: [
                    .domain(testing: .photoLog)
                ]
            )
        )
    ]
)
