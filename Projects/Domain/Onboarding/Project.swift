//
//  Project.swift
//  DomainOnboarding
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Domain.name + Module.Domain.onboarding.rawValue,
    targets: [
        .domain(
            interface: .onboarding,
            config: .init(
                dependencies: [
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .domain(
            implements: .onboarding,
            config: .init(
                dependencies: [
                    .domain(interface: .onboarding),
                    .core(interface: .network),
                    .external(dependency: .ComposableArchitecture)
                ]
            )
        ),
        .domain(
            testing: .onboarding,
            config: .init(
                dependencies: [
                    .domain(interface: .onboarding)
                ]
            )
        ),
        .domain(
            tests: .onboarding,
            config: .init(
                dependencies: [
                    .domain(testing: .onboarding)
                ]
            )
        )
    ]
)
