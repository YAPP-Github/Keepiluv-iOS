//
//  TargetTemplates.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension Target {
    /// Feature 모듈의 루트 타겟을 생성합니다.
    /// - Parameter config: 기본 설정을 담고 있는 `TargetConfig`입니다. Feature 루트 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Feature 루트 타겟 설정이 적용된 `Target`
    static func feature(config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name
        return makeTarget(config: newConfig)
    }
    
    /// 특정 Feature 모듈의 구현 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 생성할 Feature 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 구현 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Feature 구현 타겟 설정이 적용된 `Target`
    static func feature(implements module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue
        newConfig.sources = .sources
        
        return makeTarget(config: newConfig)
    }
    
    /// Feature 모듈의 유닛 테스트 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 테스트 타겟을 생성할 Feature 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 테스트 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Feature 유닛 테스트 타겟 설정이 적용된 `Target`
    static func feature(tests module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue + "Tests"
        newConfig.product = .unitTests
        newConfig.sources = .tests
        
        return makeTarget(config: newConfig)
    }
    
    /// Feature 모듈의 테스트 지원 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 테스트 지원 타겟을 생성할 Feature 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 테스트 지원 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Feature 테스트 지원 타겟 설정이 적용된 `Target`
    static func feature(testing module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue + "Testing"
        newConfig.sources = .testing
        
        return makeTarget(config: newConfig)
    }
    
    /// Feature 모듈의 인터페이스 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 인터페이스 타겟을 생성할 Feature 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 인터페이스 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Feature 인터페이스 타겟 설정이 적용된 `Target`
    static func feature(interface module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue + "Interface"
        newConfig.sources = .interface
        
        return makeTarget(config: newConfig)
    }
    
    /// Feature 모듈의 예제 앱 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 예제 앱 타겟을 생성할 Feature 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 예제 앱 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Feature 예제 앱 타겟 설정이 적용된 `Target`
    static func feature(example module: Module.Feature, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Feature.name + module.rawValue + "Example"
        newConfig.sources = .exampleSources
        newConfig.product = .app
        
        return makeTarget(config: newConfig)
    }
}
