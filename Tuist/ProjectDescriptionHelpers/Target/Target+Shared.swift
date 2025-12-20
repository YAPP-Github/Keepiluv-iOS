//
//  Target+Shared.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension Target {
    static func shared(config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Shared.name
        
        return makeTarget(config: newConfig)
    }
    
    static func shared(implements module: Module.Shared, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Shared.name + module.rawValue
       
        // TODO: - DesignSystem 모듈 추가 후 주석 풀기
//        if module == .designSystem {
//            newConfig.sources = .sources
//            newConfig.resources = ["Resources/**"]
//            newConfig.product = .staticFramework
//        }
        
        return makeTarget(config: newConfig)
    }
}
