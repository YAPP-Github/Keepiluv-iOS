//
//  TargetDependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 1/3/26.
//

import ProjectDescription

public extension TargetDependency {
    struct SPM {
        public static let composableArchitecture: TargetDependency = .external(name: "ComposableArchitecture")
    }
}
