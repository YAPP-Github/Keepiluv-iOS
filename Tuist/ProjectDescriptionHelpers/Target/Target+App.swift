//
//  Target+App.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension Target {
    static func app(
        implements module: Module.App,
        config: TargetConfig
    ) -> Self {
        var newConfig = config
        newConfig.name = Module.App.name + module.rawValue
        
        switch module {
        case .iOS:
            newConfig.name = Project.Environment.appName
            newConfig.destinations = .iOS
            newConfig.product = .app
            newConfig.bundleId = Project.Environment.BundleId.bundlePrefix
            newConfig.resources = ["Resources/**"]
            newConfig.productName = Project.Environment.appName
            newConfig.deploymentTargets = Project.Environment.deploymentTarget
        }
        
        return .makeTarget(config: newConfig)
    }
    
    static func app(
        extension module: Module.Extension,
        config: TargetConfig
    ) -> Self {
        var newConfig = config
        newConfig.name = Module.Extension.name + module.rawValue
        newConfig.deploymentTargets = Project.Environment.deploymentTarget
        newConfig.destinations = .iOS

        return .makeTarget(config: newConfig)
    }}
