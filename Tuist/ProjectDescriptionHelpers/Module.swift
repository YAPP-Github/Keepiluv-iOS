//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/18/25.
//

import ProjectDescription

public enum Module {
    case feature(Feature)
    case domain(Domain)
    case core(Core)
    case shared(Shared)
}

public extension Module {
    enum App: String, CaseIterable {
        case iOS
        
        public static let name: String = "Twix"
    }
    
    enum Extension: String, CaseIterable {
        case deletePlz
        
        public static let name: String = "Extension"
    }
}


public extension Module {
    enum Feature: String, CaseIterable {
        case onboarding = "Onboarding"
        
        public static let name: String = "Feature"
    }
}

public extension Module {
    enum Domain: String, CaseIterable {
        case auth = "Auth"
        
        public static let name: String = "Domain"
    }
}

public extension Module {
    enum Core: String, CaseIterable {
        case network = "Network"
        
        public static let name: String = "Core"
    }
}

public extension Module {
    enum Shared: String, CaseIterable {
        case designSystem = "DesignSystem"
        
        public static let name: String = "Shared"
    }
}
