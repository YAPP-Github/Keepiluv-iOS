import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.name + Module.Core.logging.rawValue,
    targets: [
        // Interface - Pulse 의존성 없음
        .core(
            interface: .logging,
            config: .init(
                dependencies: []
            )
        ),

        // Release Implementation - Pulse 없음
        .core(
            implements: .logging,
            config: .init(
                dependencies: [
                    .core(interface: .logging),
                    .core(interface: .network)
                ]
            )
        ),

        // Debug Implementation - Pulse 포함
        .makeTarget(
            config: .init(
                name: "CoreLoggingDebug",
                product: .staticLibrary,
                bundleId: "org.yapp.twix.corelogging.debug",
                sources: "DebugSources/**",
                dependencies: [
                    .core(interface: .logging),
                    .core(interface: .network),
                    .core(implements: .logging),
                    .external(dependency: .Pulse),
                    .external(dependency: .PulseUI)
                ]
            )
        ),

        // Testing
        .core(
            testing: .logging,
            config: .init(
                dependencies: [
                    .core(interface: .logging)
                ]
            )
        ),

        // Tests
        .core(
            tests: .logging,
            config: .init(
                dependencies: [
                    .core(testing: .logging)
                ]
            )
        )
    ]
)
