import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.goalDetail.rawValue,
    targets: [
        .feature(
            interface: .goalDetail,
            config: .init(
                dependencies: [
                    .feature(interface: .proofPhoto),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .feature(
            implements: .goalDetail,
            config: .init(
                dependencies: [
                    .feature(interface: .goalDetail),
                    .feature(interface: .proofPhoto),
                    .core(interface: .captureSession),
                    .shared(implements: .designSystem),
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
                    infoPlist: .extendingDefault(
                        with: Project.Environment.InfoPlist.launchScreen.merging(
                            [
                                "NSCameraUsageDescription": "UseCamera"
                            ],
                            uniquingKeysWith: { current, _ in current }
                        )
                    ),
                    dependencies: [
                        .shared(implements: .designSystem),
                        .feature(implements: .goalDetail),
                        .feature(implements: .proofPhoto),
                        .core(implements: .captureSession),
                        .external(dependency: .ComposableArchitecture)
                ]
            )
        )
    ]
)
