import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.name + Module.Core.captureSession.rawValue,
    targets: [
        .core(
            interface: .captureSession,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .core(
            implements: .captureSession,
            config: .init(
                dependencies: [
                    .core(interface: .captureSession),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .core(
            testing: .captureSession,
            config: .init(
                dependencies: [
                    .core(interface: .captureSession)
                ]
            )
        ),
        .core(
            tests: .captureSession,
            config: .init(
                dependencies: [
                    .core(testing: .captureSession)
                ]
            )
        )
    ]
)
