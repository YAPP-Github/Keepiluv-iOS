//
//  SourceFileList.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension SourceFilesList {
    static let interface: SourceFilesList = "Interface/Sources/**"
    static let sources: SourceFilesList = "Sources/**"
    static let exampleSources: SourceFilesList = "Example/Sources/**"
    static let testing: SourceFilesList = "Testing/Sources/**"
    static let tests: SourceFilesList = "Tests/Sources/**"
}
