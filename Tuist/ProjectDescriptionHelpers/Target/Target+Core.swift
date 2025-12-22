//
//  Target+Core.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension Target {
    static func core(config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Core.name
        return makeTarget(config: newConfig)
    }
    
    static func core(implements module: Module.Core, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Core.name + module.rawValue
        newConfig.sources = .sources
        
        return makeTarget(config: newConfig)
    }
    
    static func core(tests module: Module.Core, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Core.name + module.rawValue + "Tests"
        newConfig.product = .unitTests
        newConfig.sources = .tests
        
        return makeTarget(config: newConfig)
    }
    
    static func core(testing module: Module.Core, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Core.name + module.rawValue + "Testing"
        newConfig.sources = .testing
        
        return makeTarget(config: newConfig)
    }
    
    static func core(interface module: Module.Core, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Core.name + module.rawValue + "Interface"
        newConfig.sources = .interface
        
        return makeTarget(config: newConfig)
    }
}
