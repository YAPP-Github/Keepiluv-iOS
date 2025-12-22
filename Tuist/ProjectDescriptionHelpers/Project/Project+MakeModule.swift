//
//  Project+MakeModule.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/18/25.
//

import ProjectDescription

public extension Project {
    static func makeModule(
        name: String,
        organizationName: String? = nil,
        classPrefix: String? = nil,
        options: Project.Options = .options(),
        packages: [Package] = [],
        settings: Settings? = nil,
        targets: [Target] = [],
        schemes: [Scheme] = [],
        fileHeaderTemplate: FileHeaderTemplate? = nil,
        additionalFiles: [FileElement] = [],
        resourceSynthesizers: [ResourceSynthesizer] = []
    ) -> Self {
        return .init(
            name: name,
            organizationName: organizationName,
            classPrefix: classPrefix,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes,
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}
