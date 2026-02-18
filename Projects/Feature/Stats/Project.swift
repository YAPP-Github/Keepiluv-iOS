import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.stats.rawValue,
    targets: [
        .feature(
            interface: .stats,
            config: .init()
        ),
        .feature(
            implements: .stats,
            config: .init(
                dependencies: [
                    .feature(interface: .stats)
                ]
            )
        ),
        .feature(
            testing: .stats,
            config: .init(
                dependencies: [
                    .feature(interface: .stats)
                ]
            )
        ),
        .feature(
            tests: .stats,
            config: .init(
                dependencies: [
                    .feature(testing: .stats)
                ]
            )
        ),
        .feature(
            example: .stats,
            config: .init(
                infoPlist: .extendingDefault(with: [
                    "UIUserInterfaceStyle": "Light"
                ]),
                dependencies: [
                    .feature(interface: .stats)
                ]
            )
        )
    ]
)