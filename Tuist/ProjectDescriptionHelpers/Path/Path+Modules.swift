//
//  Path+Modules.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/20/25.
//

import Foundation
import ProjectDescription

public extension ProjectDescription.Path {
    static var app: Self {
        return .relativeToRoot("Projects/\(Module.App.name)")
    }
}

public extension ProjectDescription.Path {
    static var feature: Self {
        return .relativeToRoot("Projects/\(Module.Feature.name)")
    }
    
    static func feature(implementation module: Module.Feature) -> Self {
        return .relativeToRoot("Projects/\(Module.Feature.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var domain: Self {
        return .relativeToRoot("Projects/\(Module.Domain.name)")
    }
    
    static func domain(implementation module: Module.Domain) -> Self {
        return .relativeToRoot("Projects/\(Module.Domain.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var core: Self {
        return .relativeToRoot("Projects/\(Module.Core.name)")
    }
    
    static func core(implementation module: Module.Core) -> Self {
        return .relativeToRoot("Projects/\(Module.Core.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var shared: Self {
        return .relativeToRoot("Projects/\(Module.Shared.name)")
    }
    
    static func shared(implementation module: Module.Shared) -> Self {
        return .relativeToRoot("Projects/\(Module.Shared.name)/\(module.rawValue)")
    }
}
