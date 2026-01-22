//
//  ProofPhotoReducer.swift
//  FeatureGoalDetailInterface
//
//  Created by 정지훈 on 1/22/26.
//

import SwiftUI

import ComposableArchitecture

/// ProofPhoto 화면의 상태와 액션을 정의하는 리듀서입니다.
@Reducer
public struct ProofPhotoReducer {
    let reducer: Reduce<State, Action>

    @ObservableState
    /// ProofPhoto 화면 렌더링에 필요한 상태입니다.
    public struct State {
        public var titleText: String
        public var commentText: String
        public var galleryThumbnail: Image
        public var scopeText: String = "1x"

        /// 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = ProofPhotoReducer.State(
        ///     titleText: "인증샷을 올려보세요~",
        ///     commentText: "안녕하세요",
        ///     galleryThumbnail: image
        /// )
        /// ```
        public init(
            titleText: String,
            commentText: String,
            galleryThumbnail: Image
        ) {
            self.titleText = titleText
            self.commentText = commentText
            self.galleryThumbnail = galleryThumbnail
        }
    }

    /// ProofPhoto 화면에서 발생하는 액션입니다.
    public enum Action {
        case closeButtonTapped
        case flashButtonTapped
        case zoomButtonTapped
        case galleryButtonTapped
        case captureButtonTapped
        case switchCameraButtonTapped
    }

    /// 외부에서 주입된 Reduce로 리듀서를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = ProofPhotoReducer(
    ///     reducer: Reduce { _, _ in .none }
    /// )
    /// ```
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }

    public var body: some ReducerOf<Self> {
        reducer
    }
}
