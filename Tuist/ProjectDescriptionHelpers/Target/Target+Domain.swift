//
//  Target+Domain.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension Target {
    /// Domain 모듈의 루트 타겟을 생성합니다.
    /// - Parameter config: 기본 설정을 담고 있는 `TargetConfig`입니다. Domain 루트 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Domain 루트 타겟 설정이 적용된 `Target`
    static func domain(config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name
        return makeTarget(config: newConfig)
    }
    
    /// 특정 Domain 모듈의 구현 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 생성할 Domain 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 구현 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Domain 구현 타겟 설정이 적용된 `Target`
    static func domain(implements module: Module.Domain, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name + module.rawValue
        newConfig.sources = .sources
        
        return makeTarget(config: newConfig)
    }
    
    /// Domain 모듈의 유닛 테스트 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 테스트 타겟을 생성할 Domain 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 테스트 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Domain 유닛 테스트 타겟 설정이 적용된 `Target`
    static func domain(tests module: Module.Domain, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name + module.rawValue + "Tests"
        newConfig.product = .unitTests
        newConfig.sources = .tests
        
        return makeTarget(config: newConfig)
    }
    
    /// Domain 모듈의 테스트 지원 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 테스트 지원 타겟을 생성할 Domain 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 테스트 지원 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Domain 테스트 지원 타겟 설정이 적용된 `Target`
    static func domain(testing module: Module.Domain, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name + module.rawValue + "Testing"
        newConfig.sources = .testing
        
        return makeTarget(config: newConfig)
    }
    
    /// Domain 모듈의 인터페이스 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 인터페이스 타겟을 생성할 Domain 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 인터페이스 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: Domain 인터페이스 타겟 설정이 적용된 `Target`
    static func domain(interface module: Module.Domain, config: TargetConfig) -> Self {
        var newConfig = config
        newConfig.name = Module.Domain.name + module.rawValue + "Interface"
        newConfig.sources = .interface
        
        return makeTarget(config: newConfig)
    }
}
