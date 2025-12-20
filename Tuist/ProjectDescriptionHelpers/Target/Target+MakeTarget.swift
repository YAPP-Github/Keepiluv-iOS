//
//  Target+MakeTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by 정지훈 on 12/19/25.
//

import ProjectDescription

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

    public init(
        name: String = "",
        destinations: Destinations = .iOS,
        product: Product = .staticLibrary,
        productName: String? = nil,
        bundleId: String = "",
        deploymentTargets: DeploymentTargets? = nil,
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

public extension Target {
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
