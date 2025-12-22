//
//  TargetDependency+Modules.swift
//  Manifests
//
//  Created by 정지훈 on 12/20/25.
//

import Foundation
import ProjectDescription

public extension TargetDependency {
    static var app: Self {
        return .project(target: Module.App.name, path: .app)
    }
    
    static func app(implements module: Module.App) -> Self {
        return .target(name: Module.App.name + module.rawValue)
    }
}

public extension TargetDependency {
    static var feature: Self {
        return .project(target: Module.Feature.name, path: .feature)
    }
    
    static func feature(implements module: Module.Feature) -> Self {
        return .project(target: Module.Feature.name + module.rawValue, path: .feature(implementation: module))
    }
    
    static func feature(interface module: Module.Feature) -> Self {
        return .project(target: Module.Feature.name + module.rawValue + "Interface", path: .feature(implementation: module))
    }
    
    static func feature(tests module: Module.Feature) -> Self {
        return .project(target: Module.Feature.name + module.rawValue + "Tests", path: .feature(implementation: module))
    }
    
    static func feature(testing module: Module.Feature) -> Self {
        return .project(target: Module.Feature.name + module.rawValue + "Testing", path: .feature(implementation: module))
    }
    
}

public extension TargetDependency {
    static var domain: Self {
        return .project(target: Module.Domain.name, path: .domain)
    }
    
    static func domain(implements module: Module.Domain) -> Self {
        return .project(target: Module.Domain.name + module.rawValue, path: .domain(implementation: module))
    }
    
    static func domain(interface module: Module.Domain) -> Self {
        return .project(target: Module.Domain.name + module.rawValue + "Interface", path: .domain(implementation: module))
    }
    
    static func domain(tests module: Module.Domain) -> Self {
        return .project(target: Module.Domain.name + module.rawValue + "Tests", path: .domain(implementation: module))
    }
    
    static func domain(testing module: Module.Domain) -> Self {
        return .project(target: Module.Domain.name + module.rawValue + "Testing", path: .domain(implementation: module))
    }
}

public extension TargetDependency {
    static var core: Self {
        return .project(target: Module.Core.name, path: .core)
    }
    
    static func core(implements module: Module.Core) -> Self {
        return .project(target: Module.Core.name + module.rawValue, path: .core(implementation: module))
    }
    
    static func core(interface module: Module.Core) -> Self {
        return .project(target: Module.Core.name + module.rawValue + "Interface", path: .core(implementation: module))
    }
    
    static func core(tests module: Module.Core) -> Self {
        return .project(target: Module.Core.name + module.rawValue + "Tests", path: .core(implementation: module))
    }
    
    static func core(testing module: Module.Core) -> Self {
        return .project(target: Module.Core.name + module.rawValue + "Testing", path: .core(implementation: module))
    }
}

public extension TargetDependency {
    static var shared: Self {
        return .project(target: Module.Shared.name, path: .shared)
    }
    
    static func shared(implements module: Module.Shared) -> Self {
        return .project(target: Module.Shared.name + module.rawValue, path: .shared(implementation: module))
    }
    
    static func shared(interface module: Module.Shared) -> Self {
        return .project(target: Module.Shared.name + module.rawValue + "Interface", path: .shared(implementation: module))
    }
}
