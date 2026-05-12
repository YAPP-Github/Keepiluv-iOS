import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.name + Module.Core.analytics.rawValue,
    targets: [
        .core(
            interface: .analytics,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .core(
            implements: .analytics,
            config: .init(
                dependencies: [
                    .core(interface: .analytics),
                    .external(dependency: .ComposableArchitecture),
                    .external(dependency: .FirebaseAnalytics)
                ]
            )
        ),
        .core(
            testing: .analytics,
            config: .init(
                dependencies: [
                    .core(interface: .analytics)
                ]
            )
        ),
        .core(
            tests: .analytics,
            config: .init(
                dependencies: [
                    .core(testing: .analytics)
                ]
            )
        )
    ]
)
