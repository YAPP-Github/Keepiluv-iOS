//
//  Path+Modules.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/20/25.
//

import Foundation
import ProjectDescription

/// Tuist 기반 프로젝트에서 **모듈별 디렉터리 경로를 표준화하기 위한 `ProjectDescription.Path` Extension**입니다.
///
/// 이 extension은 Module enum과 함께 사용되며,  **App / Feature / Domain / Core / Shared 모듈**의
/// 루트 경로와 특정 모듈 경로를 일관된 규칙으로 제공합니다.
///
/// **TargetDependency+Modules.swift**에서 모듈 의존성에 사용할 경로를 정의할 때 활용됩니다.

public extension ProjectDescription.Path {
    /// App 타겟의 루트 경로입니다.
    static var app: Self {
        return .relativeToRoot("Projects/\(Module.App.name)")
    }
}

public extension ProjectDescription.Path {
    /// Feature 모듈의 루트 경로입니다.
    static var feature: Self {
        return .relativeToRoot("Projects/\(Module.Feature.name)")
    }
    
    /// 특정 Feature 모듈의 경로를 enum 값을 기준으로 리턴합니다
    ///
    /// module.rawValue를 폴더명으로 사용합니다.
    /// - Parameter module: Module.Feature
    /// - Returns: ``Path``
    static func feature(implementation module: Module.Feature) -> Self {
        return .relativeToRoot("Projects/\(Module.Feature.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    /// Domain 모듈의 루트 경로입니다.
    static var domain: Self {
        return .relativeToRoot("Projects/\(Module.Domain.name)")
    }
    
    /// 특정 Domain 모듈의 경로를 enum 값을 기준으로 리턴합니다
    ///
    /// module.rawValue를 폴더명으로 사용합니다.
    /// - Parameter module: Module.Domain
    /// - Returns: ``Path``
    static func domain(implementation module: Module.Domain) -> Self {
        return .relativeToRoot("Projects/\(Module.Domain.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    /// Core 모듈의 루트 경로입니다.
    static var core: Self {
        return .relativeToRoot("Projects/\(Module.Core.name)")
    }
    
    /// 특정 Core 모듈의 경로를 enum 값을 기준으로 리턴합니다
    ///
    /// module.rawValue를 폴더명으로 사용합니다.
    /// - Parameter module: Module.Core
    /// - Returns: ``Path``
    static func core(implementation module: Module.Core) -> Self {
        return .relativeToRoot("Projects/\(Module.Core.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    /// Shared 모듈의 루트 경로입니다.
    static var shared: Self {
        return .relativeToRoot("Projects/\(Module.Shared.name)")
    }
    
    /// 특정 Shared 모듈의 경로를 enum 값을 기준으로 리턴합니다
    ///
    /// module.rawValue를 폴더명으로 사용합니다.
    /// - Parameter module: Module.Shared
    /// - Returns: ``Path``
    static func shared(implementation module: Module.Shared) -> Self {
        return .relativeToRoot("Projects/\(Module.Shared.name)/\(module.rawValue)")
    }
}
