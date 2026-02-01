import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.proofPhoto.rawValue,
    targets: [
        .feature(
            interface: .proofPhoto,
            config: .init(
                dependencies: [
                    .domain(interface: .goal),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .feature(
            implements: .proofPhoto,
            config: .init(
                dependencies: [
                    .feature(interface: .proofPhoto),
                    .core(interface: .captureSession),
                    .domain(interface: .goal),
                    .shared(implements: .designSystem),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .feature(
            testing: .proofPhoto,
            config: .init(
                dependencies: [
                    .feature(interface: .proofPhoto)
                ]
            )
        ),
        .feature(
            tests: .proofPhoto,
            config: .init(
                dependencies: [
                    .feature(testing: .proofPhoto)
                ]
            )
        ),    
        .feature(
            example: .proofPhoto,
            config: .init(
                dependencies: [
                    .feature(interface: .proofPhoto)
                ]
            )
        )
    ]
)
