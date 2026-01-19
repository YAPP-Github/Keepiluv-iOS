import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.name + Module.Core.storage.rawValue,
    targets: [
        .core(
            interface: .storage,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .core(
            implements: .storage,
            config: .init(
                dependencies: [
                    .core(interface: .storage),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .core(
            testing: .storage,
            config: .init(
                dependencies: [
                    .core(interface: .storage)
                ]
            )
        ),
        .core(
            tests: .storage,
            config: .init(
                dependencies: [
                    .core(testing: .storage)
                ]
            )
        )
    ]
)
