import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Domain.name + Module.Domain.goal.rawValue,
    targets: [
        .domain(
            interface: .goal,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture),
                    .shared(implements: .designSystem)
                ]
            )
        ),
        .domain(
            implements: .goal,
            config: .init(
                dependencies: [
                    .core(interface: .network),
                    .domain(interface: .goal),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .domain(
            testing: .goal,
            config: .init(
                dependencies: [
                    .domain(interface: .goal)
                ]
            )
        ),
        .domain(
            tests: .goal,
            config: .init(
                dependencies: [
                    .domain(testing: .goal)
                ]
            )
        )
    ]
)
