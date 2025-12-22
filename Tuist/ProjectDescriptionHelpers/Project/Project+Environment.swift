//
//  Project+Environment.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

public extension Project {
    enum Environment {
        public static let appName = "Twix"
        public static let deploymentTarget = DeploymentTargets.iOS("17.0")
    }
}

extension Project.Environment {
    enum BundleId {
        public static let bundlePrefix = "com.yapp.twix"
        public static let notification = bundlePrefix + ".notification.extension"
        public static let widget = bundlePrefix + ".widget.extension"
    }
}
