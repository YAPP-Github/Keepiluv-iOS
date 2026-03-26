import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Domain.name + Module.Domain.notification.rawValue,
    targets: [
        .domain(
            interface: .notification,
            config: .init(
                dependencies: [
                    .core(interface: .network),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .domain(
            implements: .notification,
            config: .init(
                dependencies: [
                    .domain(interface: .notification),
                    .core(interface: .network),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .domain(
            testing: .notification,
            config: .init(
                dependencies: [
                    .domain(interface: .notification)
                ]
            )
        ),
        .domain(
            tests: .notification,
            config: .init(
                dependencies: [
                    .domain(testing: .notification)
                ]
            )
        )
    ]
)