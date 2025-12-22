//
//  TargetTemplates.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension Target {
    static func feature(config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name
        return makeTarget(config: newConfig)
    }
    
    static func feature(implements module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue
        newConfig.sources = .sources
        
        return makeTarget(config: newConfig)
    }
    
    static func feature(tests module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue + "Tests"
        newConfig.product = .unitTests
        newConfig.sources = .tests
        
        return makeTarget(config: newConfig)
    }
    
    static func feature(testing module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue + "Testing"
        newConfig.sources = .testing
        
        return makeTarget(config: newConfig)
    }
    
    static func feature(interface module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue + "Interface"
        newConfig.sources = .interface
        
        return makeTarget(config: newConfig)
    }
    
    static func feature(example module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue + "Example"
        newConfig.sources = .exampleSources
        newConfig.product = .app
        
        return makeTarget(config: newConfig)
    }
}
