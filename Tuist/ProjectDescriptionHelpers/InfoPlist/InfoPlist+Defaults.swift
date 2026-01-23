//
//  InfoPlist+Defaults.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 1/23/26.
//

import ProjectDescription

public extension Project.Environment {
    enum InfoPlist {
        public static let launchScreen: [String: Plist.Value] = [
            "UILaunchScreen": [
                "UIColorName": "LaunchScreenBackground"
            ]
        ]
    }
}

public extension InfoPlist {
    func mergingLaunchScreenDefaults() -> InfoPlist {
        let launchScreen = Project.Environment.InfoPlist.launchScreen
        
        switch self {
        case .default:
            return .extendingDefault(with: launchScreen)
            
        case .extendingDefault(let dict):
            let merged = dict.merging(launchScreen) { current, _ in current }
            return .extendingDefault(with: merged)
            
        default:
            return self
        }
    }
}
