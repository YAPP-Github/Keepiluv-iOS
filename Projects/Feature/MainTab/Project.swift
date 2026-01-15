import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.mainTab.rawValue,
    targets: [
        .feature(
            interface: .mainTab,
            config: .init()
        ),
        .feature(
            implements: .mainTab,
            config: .init(
                dependencies: [
                    .feature(interface: .mainTab),
                    .external(dependency: .ComposableArchitecture),
                    .core(implements: .logging)
                ]
            )
        )
    ]
)
