//
//  SourceFileList.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

/// SourceFilesList에 프로젝트에서 사용하는 소스 경로 패턴을 정의한 Extension 입니다.
///
/// 각 static 프로퍼티는 `Target`의 `sources` 파라미터에 그대로 전달할 수 있으며,
/// 모듈 구조 변경 시 이 파일만 수정하면 되도록 중앙화하는 역할을 합니다.
///
/// **Target+(App/Core/Domain/Feature/Shared).swift**에서 타겟을 생성할 때, 각 타겟 타입(Interface, 구현, Example, Test 등)에 맞는
/// 소스 파일 경로를 일관된 규칙으로 관리하기 위해 사용됩니다.
public extension SourceFilesList {
    /// Interface 타겟의 소스 경로 패턴입니다.
    static let interface: SourceFilesList = "Interface/Sources/**"
    /// 구현 타겟의 소스 경로 패턴입니다.
    static let sources: SourceFilesList = "Sources/**"
    /// 예제 앱 타겟의 소스 경로 패턴입니다.
    static let exampleSources: SourceFilesList = "Example/Sources/**"
    /// Test 지원 타겟의 소스 경로 패턴입니다.
    static let testing: SourceFilesList = "Testing/Sources/**"
    /// Unit Test 타겟의 소스 경로 패턴입니다.
    static let tests: SourceFilesList = "Tests/Sources/**"
}
