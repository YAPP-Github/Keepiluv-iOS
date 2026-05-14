import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.name + Module.Core.crashlytics.rawValue,
    targets: [
        .core(
            interface: .crashlytics,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .core(
            implements: .crashlytics,
            config: .init(
                dependencies: [
                    .core(interface: .crashlytics),
                    .external(dependency: .ComposableArchitecture),
                    .external(dependency: .FirebaseCrashlytics)
                ]
            )
        )
    ]
)
