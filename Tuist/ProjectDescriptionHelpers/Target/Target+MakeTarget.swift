//
//  Target+MakeTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

/// Tuist `Target` 생성을 위한 Struct입니다.
/// Tuist 기존 `Target.target`의 파라미터를 기본값과 함께 그대로 보유합니다.
public struct TargetConfig {
    var name: String
    var destinations: Destinations
    var product: Product
    var productName: String?
    var bundleId: String
    var deploymentTargets: DeploymentTargets?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var buildableFolders: [BuildableFolder]
    var copyFiles: [CopyFilesAction]?
    var headers: Headers?
    var entitlements: Entitlements?
    var scripts: [TargetScript]
    var dependencies: [TargetDependency]
    var settings: Settings?
    var coreDataModels: [CoreDataModel]
    var environmentVariables: [String: EnvironmentVariable]
    var launchArguments: [LaunchArgument]
    var additionalFiles: [FileElement]
    var buildRules: [BuildRule]
    var mergedBinaryType: MergedBinaryType
    var mergeable: Bool
    var onDemandResourcesTags: OnDemandResourcesTags?
    var metadata: TargetMetadata

    /// 모듈 규칙에 맞는 기본값으로 `TargetConfig`를 생성합니다.
    /// 값은 `makeTarget`에서 `Target.target`로 그대로 전달됩니다.
    /// - Parameters:
    ///   - name: 타겟의 이름입니다.
    ///   - destinations: 타겟이 빌드될 플랫폼/디바이스 목적지 집합입니다(예: iOS, iPadOS 등).
    ///   - product: 생성할 타겟의 제품 타입입니다(예: app, staticLibrary, framework, unitTests 등).
    ///   - productName: 빌드 산출물(제품)의 표시 이름입니다. 지정하지 않으면 `name`을 사용합니다.
    ///   - bundleId: 타겟의 번들 식별자(Bundle Identifier)입니다.
    ///   - deploymentTargets: 타겟의 최소 배포 버전(플랫폼별)을 정의합니다.
    ///   - infoPlist: 타겟의 Info.plist 설정입니다(`.default`, `.file`, `.extendingDefault` 등).
    ///   - sources: 타겟에 포함될 소스 파일 경로 패턴입니다.
    ///   - resources: 타겟에 포함될 리소스 파일 경로 패턴입니다.
    ///   - buildableFolders: Xcode에서 빌드 가능한 폴더(폴더 레퍼런스)를 정의합니다.
    ///   - copyFiles: 타겟을 위한 빌드 단계(Build Phase)의 파일 복사 작업들입니다.
    ///   - headers: 타겟의 헤더 파일들입니다.
    ///   - entitlements: 타겟의 권한(Entitlements) 설정입니다.
    ///   - scripts: 빌드 단계에서 실행할 스크립트 목록입니다.
    ///   - dependencies: 타겟이 의존하는 다른 타겟/패키지/SDK 목록입니다.
    ///   - settings: 타겟의 빌드 설정입니다.
    ///   - coreDataModels: 타겟에 포함될 Core Data 모델 목록입니다.
    ///   - environmentVariables: 런치 시 주입할 환경 변수 목록입니다.
    ///   - launchArguments: 런치 시 주입할 실행 인자 목록입니다.
    ///   - additionalFiles: 소스/리소스로 분류되지 않지만 Xcode 내에서 함께 관리할 파일 목록입니다.
    ///   - buildRules: 커스텀 빌드 룰 목록입니다.
    ///   - mergedBinaryType: 병합 바이너리(Merged Binary) 기능 사용 시 바이너리 타입을 정의합니다.
    ///   - mergeable: 타겟이 병합 가능한 바이너리로 처리될지 여부입니다.
    ///   - onDemandResourcesTags: On-Demand Resources 태그 설정입니다.
    ///   - metadata: 타겟 메타데이터 설정입니다
    
    public init(
        name: String = "",
        destinations: Destinations = .iOS,
        product: Product = .staticLibrary,
        productName: String? = nil,
        bundleId: String = "",
        deploymentTargets: DeploymentTargets? = Project.Environment.deploymentTarget,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = nil,
        resources: ResourceFileElements? = nil,
        buildableFolders: [BuildableFolder] = [],
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil,
        coreDataModels: [CoreDataModel] = [],
        environmentVariables: [String: EnvironmentVariable] = [:],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        buildRules: [BuildRule] = [],
        mergedBinaryType: MergedBinaryType = .disabled,
        mergeable: Bool = false,
        onDemandResourcesTags: OnDemandResourcesTags? = nil,
        metadata: TargetMetadata = .default
    ) {
        self.name = name
        self.destinations = destinations
        self.product = product
        self.productName = productName
        self.bundleId = bundleId
        self.deploymentTargets = deploymentTargets
        self.infoPlist = infoPlist
        self.sources = sources
        self.resources = resources
        self.buildableFolders = buildableFolders
        self.copyFiles = copyFiles
        self.headers = headers
        self.entitlements = entitlements
        self.scripts = scripts
        self.dependencies = dependencies
        self.settings = settings
        self.coreDataModels = coreDataModels
        self.environmentVariables = environmentVariables
        self.launchArguments = launchArguments
        self.additionalFiles = additionalFiles
        self.buildRules = buildRules
        self.mergedBinaryType = mergedBinaryType
        self.mergeable = mergeable
        self.onDemandResourcesTags = onDemandResourcesTags
        self.metadata = metadata
    }
}

/// `TargetConfig`를 기반으로 Tuist `Target`을 생성하는 extension입니다.
///
/// 이 확장은 `Target.target(...)` 호출에 필요한 파라미터들을 `TargetConfig`로 캡슐화해,
/// 각 모듈(Target+App/Core/Domain/Feature/Shared 등)에서 타겟을 생성할 때
/// 공통 생성 로직을 재사용할 수 있도록 돕습니다.
///
/// 모듈별로 필요한 설정(이름, 소스/리소스 경로, 번들 ID 등)은 `TargetConfig`에서 조정한 뒤,
/// 최종적으로 이 메서드를 통해 `Target`으로 변환됩니다.
public extension Target {
    /// `TargetConfig`로부터 Tuist `Target`을 생성합니다.
    ///
    /// 설정 값은 `Target.target`에 전달됩니다.
    /// - Parameter config: `Target.target(...)`에 전달할 값을 담고 있는 `TargetConfig`입니다.
    /// - Returns: `TargetConfig`의 설정이 적용된 Tuist `Target`
    static func makeTarget(config: TargetConfig) -> Self {
        return .target(
            name: config.name,
            destinations: config.destinations,
            product: config.product,
            productName: config.productName,
            bundleId: config.bundleId,
            deploymentTargets: config.deploymentTargets,
            infoPlist: config.infoPlist,
            sources: config.sources,
            resources: config.resources,
            buildableFolders: config.buildableFolders,
            copyFiles: config.copyFiles,
            headers: config.headers,
            entitlements: config.entitlements,
            scripts: config.scripts,
            dependencies: config.dependencies,
            settings: config.settings,
            coreDataModels: config.coreDataModels,
            environmentVariables: config.environmentVariables,
            launchArguments: config.launchArguments,
            additionalFiles: config.additionalFiles,
            buildRules: config.buildRules,
            mergedBinaryType: config.mergedBinaryType,
            mergeable: config.mergeable,
            onDemandResourcesTags: config.onDemandResourcesTags,
            metadata: config.metadata
        )
    }
}
