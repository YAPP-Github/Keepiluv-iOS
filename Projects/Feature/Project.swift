import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name,
    targets: [
        .feature(
            config: .init(
                sources: .sources,
                dependencies: [
                    .external(dependency: .ComposableArchitecture),
                    .core(implements: .logging),
                    .domain(implements: .goal),
                    .domain(implements: .onboarding),
                ] + Module.Feature.allCases.flatMap { [
                    .feature(interface: $0),
                    .feature(implements: $0)
                ] }
            )
        )
    ]
)
