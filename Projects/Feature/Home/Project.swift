import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.home.rawValue,
    targets: [
        .feature(
            interface: .home,
            config: .init(
                dependencies: [
                    .domain(interface: .goal),
                    .shared(implements: .designSystem),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .feature(
            implements: .home,
            config: .init(
                dependencies: [
                    .domain(interface: .goal),
                    .feature(interface: .home),
                    .shared(implements: .designSystem),
                    .shared(implements: .util),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .feature(
            testing: .home,
            config: .init(
                dependencies: [
                    .feature(interface: .home)
                ]
            )
        ),
        .feature(
            tests: .home,
            config: .init(
                dependencies: [
                    .feature(testing: .home)
                ]
            )
        ),    
        .feature(
            example: .home,
            config: .init(
                dependencies: [
                    .feature(implements: .home),
                    .feature(interface: .home),
                    .domain(interface: .goal),
                    .shared(implements: .designSystem),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        )
    ]
)
