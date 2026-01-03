//
//  TargetDependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 1/3/26.
//

import ProjectDescription


/// `TargetDependency`에 Swift Package Manager(SPM) 기반 의존성 접근자를 제공합니다.
///
/// 외부 Swift Package 의존성을 Tuist Target에서 일관된 방식으로 참조하기 위해 사용됩니다.
public extension TargetDependency {
    /// Swift Package Manager로 관리되는 외부 라이브러리 모음입니다.
    ///
    /// 각 static 프로퍼티는 하나의 SPM 패키지를 나타내며,
    /// `TargetDependency.external` 형태로 정의됩니다.
    struct SPM {
        public static let composableArchitecture: TargetDependency = .external(name: "ComposableArchitecture")
    }
}
