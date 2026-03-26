import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.name + Module.Core.push.rawValue,
    targets: [
        .core(
            interface: .push,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .core(
            implements: .push,
            config: .init(
                dependencies: [
                    .core(interface: .push),
                    .external(dependency: .ComposableArchitecture),
                    .external(dependency: .FirebaseMessaging)
                ]
            )
        )
    ]
)
