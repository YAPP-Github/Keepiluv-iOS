import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.goalDetail.rawValue,
    targets: [
        .feature(
            interface: .goalDetail,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .feature(
            implements: .goalDetail,
            config: .init(
                dependencies: [
                    .feature(interface: .goalDetail),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .feature(
            testing: .goalDetail,
            config: .init(
                dependencies: [
                    .feature(interface: .goalDetail)
                ]
            )
        ),
        .feature(
            tests: .goalDetail,
            config: .init(
                dependencies: [
                    .feature(testing: .goalDetail)
                ]
            )
        ),    
        .feature(
            example: .goalDetail,
            config: .init(
                dependencies: [
                    .feature(interface: .goalDetail),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        )
    ]
)
