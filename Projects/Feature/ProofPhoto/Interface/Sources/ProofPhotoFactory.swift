//
//  ProofPhotoFactory.swift
//  FeatureProofPhotoInterface
//
//  Created by 정지훈 on 1/25/26.
//

import SwiftUI

import ComposableArchitecture

/// ProofPhoto 화면을 생성하는 팩토리입니다.
public struct ProofPhotoFactory: Sendable {
    public var makeView: @MainActor (StoreOf<ProofPhotoReducer>) -> AnyView

    /// 팩토리를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let factory = ProofPhotoFactory { store in
    ///     AnyView(ProofPhotoView(store: store))
    /// }
    /// ```
    public init(
        makeView: @escaping @MainActor (StoreOf<ProofPhotoReducer>) -> AnyView
    ) {
        self.makeView = makeView
    }
}

extension ProofPhotoFactory: TestDependencyKey {
    public static let testValue = Self { _ in
        assertionFailure("ProofPhotoFactory.makeView is unimplemented")
        return AnyView(EmptyView())
    }
}

public extension DependencyValues {
    var proofPhotoFactory: ProofPhotoFactory {
        get { self[ProofPhotoFactory.self] }
        set { self[ProofPhotoFactory.self] = newValue }
    }
}
