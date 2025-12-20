//
//  Project.swift
//  Templates
//
//  Created by 정지훈 on 12/18/25.
//

import ProjectDescription

private let layerAttribute = Template.Attribute.required("layer")
private let nameAttribute = Template.Attribute.required("name")
private let authorAttribute = Template.Attribute.required("author")
private let dateAttribute = Template.Attribute.required("date")

private let template = Template(
    description: "Create a new Module",
    attributes: [
        nameAttribute,
        layerAttribute,
        authorAttribute,
        dateAttribute
    ],
    items: [
        .file(
            path: "Projects/\(layerAttribute)/\(nameAttribute)/Sources/Source.swift",
            templatePath: "Source.stencil"
        )
    ]
)
