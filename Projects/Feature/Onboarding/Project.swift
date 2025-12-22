import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.onboarding.rawValue,
    targets: [    
        .feature(
            interface: .onboarding,
            config: .init()
        ),
        .feature(
            implements: .onboarding,
            config: .init(
                dependencies: [
                    .feature(interface: .onboarding)
                ]
            )
        ),
        .feature(
            testing: .onboarding,
            config: .init(
                dependencies: [
                    .feature(interface: .onboarding)
                ]
            )
        ),
        .feature(
            tests: .onboarding,
            config: .init(
                dependencies: [
                    .feature(testing: .onboarding)
                ]
            )
        ),
    
        .feature(
            example: .onboarding,
            config: .init(
                dependencies: [
                    .feature(interface: .onboarding)
                ]
            )
        )

    ]
)
