//
//  Target+Domain.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension Target {
    static func domain(config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name
        return makeTarget(config: newConfig)
    }
    
    static func domain(implements module: Module.Domain, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name + module.rawValue
        newConfig.sources = .sources
        
        return makeTarget(config: newConfig)
    }
    
    static func domain(tests module: Module.Domain, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name + module.rawValue + "Tests"
        newConfig.product = .unitTests
        newConfig.sources = .tests
        
        return makeTarget(config: newConfig)
    }
    
    static func domain(testing module: Module.Domain, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name + module.rawValue + "Testing"
        newConfig.sources = .testing
        
        return makeTarget(config: newConfig)
    }
    
    static func domain(interface module: Module.Domain, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name + module.rawValue + "Interface"
        newConfig.sources = .interface
        
        return makeTarget(config: newConfig)
    }
}
