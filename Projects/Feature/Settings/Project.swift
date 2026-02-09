import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.settings.rawValue,
    targets: [
        .feature(
            interface: .settings,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture),
                    .shared(implements: .util),
                    .shared(implements: .designSystem)
                ]
            )
        ),
        .feature(
            implements: .settings,
            config: .init(
                dependencies: [
                    .feature(interface: .settings),
                    .core(interface: .network),
                    .domain(interface: .auth),
                    .domain(interface: .onboarding),
                    .shared(implements: .designSystem),
                    .shared(implements: .util),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .feature(
            example: .settings,
            config: .init(
                infoPlist: .extendingDefault(with: [
                    "UIUserInterfaceStyle": "Light"
                ]),
                dependencies: [
                    .feature(implements: .settings),
                    .shared(implements: .designSystem),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        )
    ]
)