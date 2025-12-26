//
//  Project+Environment.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

/// Tuist 매니페스트 전반에서 사용하는 프로젝트 환경(Environment) 정의를 모아둔 extension입니다.
///
/// 이 파일은 앱 이름, 배포 타겟, 번들 ID등 같이 여러 매니페스트에서 반복적으로 사용되는 값을
/// 관리하기 위해 존재합니다.
///
/// **Target+App.swift**에서 App 타겟을 생성할 때 메타데이터 설정에 사용됩니다.
public extension Project {
    /// Tuist 매니페스트 전반에서 사용하는 환경 상수를 정의합니다.
    /// 앱 메타데이터와 배포 타겟을 한 곳에서 관리하기 위한 목적입니다.
    enum Environment {
        /// 앱 타겟에서 사용하는 표시 이름입니다.
        public static let appName = "Twix"
        /// iOS 모듈의 최소 배포 타겟입니다.
        public static let deploymentTarget = DeploymentTargets.iOS("17.0")
    }
}

/// Project 환경 중 번들 ID 관련 상수를 정의하는 확장입니다.
///
/// 앱 타겟과 App Extension 타겟에서 사용하는 번들 ID를 명확히 분리해 관리하며,
/// 새로운 확장 타겟이 추가될 경우 이 enum에 함께 정의하도록 합니다.
public extension Project.Environment {
    /// 앱과 확장 타겟의 번들 ID 상수를 정의합니다.
    enum BundleId {
        /// 번들 ID의 기본 prefix입니다.
        public static let bundlePrefix = "com.yapp.twix"
        /// 알림 확장 번들 ID입니다.
        public static let notification = bundlePrefix + ".notification.extension"
        /// 위젯 확장 번들 ID입니다.
        public static let widget = bundlePrefix + ".widget.extension"
    }
}
