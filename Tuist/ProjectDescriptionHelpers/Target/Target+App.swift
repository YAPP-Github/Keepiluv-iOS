//
//  Target+App.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension Target {
    /// 특정 앱 모듈의 앱 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 생성할 App 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 내부에서 앱 타겟에 맞게 일부 값이 수정됩니다.
    /// - Returns: App 타겟 설정이 적용된 `Target`
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
            newConfig.sources = .sources
            newConfig.resources = ["Resources/**"]
            newConfig.productName = Project.Environment.appName
        }
        
        return .makeTarget(config: newConfig)
    }
    
    /// 앱 확장 타겟을 생성합니다.
    /// - Parameters:
    ///   - module: 생성할 App Extension 모듈 식별자입니다.
    ///   - config: 기본 설정을 담고 있는 `TargetConfig`입니다. 확장 타겟 공통 설정이 추가로 적용됩니다.
    /// - Returns: App Extension 타겟 설정이 적용된 `Target`
    static func app(
        extension module: Module.Extension,
        config: TargetConfig
    ) -> Self {
        var newConfig = config
        newConfig.name = Module.Extension.name + module.rawValue
        newConfig.destinations = .iOS
        
        return .makeTarget(config: newConfig)
    }
}
