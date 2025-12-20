//
//  Project.swift
//  Templates
//
//  Created by 정지훈 on 12/18/25.
//

import ProjectDescription

private let layerAttribute = Template.Attribute.required("layer")
private let nameAttribute = Template.Attribute.required("name")
private let targetAttribute = Template.Attribute.required("target")
private let authorAttribute = Template.Attribute.required("author")
private let dateAttribute = Template.Attribute.required("date")

private let template = Template(
    description: "New Module Template",
    attributes: [
        nameAttribute,
        layerAttribute,
        targetAttribute,
        authorAttribute,
        dateAttribute
    ],
    items: [
        .file(
            path: "Projects/\(layerAttribute)/\(nameAttribute)/Project.swift",
            templatePath: "Project.stencil"
        )
    ]
)
