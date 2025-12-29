import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Domain.name + Module.Domain.auth.rawValue,
    targets: [
        .domain(
            interface: .auth,
            config: .init()
        ),
        .domain(
            implements: .auth,
            config: .init(
                dependencies: [
                    .domain(interface: .auth)
                ]
            )
        ),
        .domain(
            testing: .auth,
            config: .init(
                dependencies: [
                    .domain(interface: .auth)
                ]
            )
        ),
        .domain(
            tests: .auth,
            config: .init(
                dependencies: [
                    .domain(testing: .auth)
                ]
            )
        )
    ]
)
