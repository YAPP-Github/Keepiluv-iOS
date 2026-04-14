//
//  ProofPhotoReducer.swift
//  FeatureProofPhotoInterface
//
//  Created by 정지훈 on 1/22/26.
//

import AVFoundation
import Foundation
import PhotosUI
import SwiftUI

import ComposableArchitecture
import DomainGoalInterface
import SharedDesignSystem

/// ProofPhoto 화면의 상태와 액션을 정의하는 리듀서입니다.
@Reducer
public struct ProofPhotoReducer {
    let reducer: Reduce<State, Action>

    /// ProofPhoto 화면 렌더링에 필요한 상태입니다.
    @ObservableState
    public struct State: Equatable {

        /// 도메인 데이터
        public struct Data: Equatable {
            public var goalId: Int64
            public var verificationDate: String
            public var imageData: Foundation.Data?
            public var commentText: String

            public init(
                goalId: Int64,
                verificationDate: String,
                commentText: String = ""
            ) {
                self.goalId = goalId
                self.verificationDate = verificationDate
                self.commentText = commentText
            }
        }

        /// UI 상태
        public struct UIState: Equatable {
            public var titleText: String = "인증샷을 올려보세요~"
            public var isCommentFocused: Bool = false
            public var scopeText: String = "1x"
            public var isFront: Bool = false
            public var isFlashOn: Bool = false
            public var isCapturing: Bool = false
            public var isUploading: Bool = false
            public var isEditing: Bool

            public init(isEditing: Bool = false) {
                self.isEditing = isEditing
            }
        }

        /// 프레젠테이션
        public struct Presentation: Equatable {
            public var toast: TXToastType?

            public init() {}
        }

        public var data: Data
        public var ui: UIState
        public var presentation: Presentation
        public var captureSession: AVCaptureSession?
        public var selectedPhotoItem: PhotosPickerItem?

        public var hasImage: Bool { data.imageData != nil }

        /// 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = ProofPhotoReducer.State(
        ///     goalId: 1,
        ///     comment: "응원합니다!",
        ///     verificationDate: "2026-02-07"
        /// )
        /// ```
        public init(
            goalId: Int64,
            comment: String = "",
            verificationDate: String,
            isEditing: Bool = false
        ) {
            self.data = Data(goalId: goalId, verificationDate: verificationDate, commentText: comment)
            self.ui = UIState(isEditing: isEditing)
            self.presentation = Presentation()
        }
    }

    /// ProofPhoto 화면에서 발생하는 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - View (사용자 이벤트)
        public enum View: Equatable {
            case onAppear
            case closeButtonTapped
            case captureButtonTapped
            case switchButtonTapped
            case flashButtonTapped
            case returnButtonTapped
            case focusChanged(Bool)
            case uploadButtonTapped
            case dimmedBackgroundTapped
            case commentTextChanged(String)
        }

        // MARK: - Internal (Reducer 내부 Effect)
        public enum Internal: Equatable {
            case setupCaptureSessionCompleted(session: AVCaptureSession)
            case captureCompleted(imageData: Foundation.Data)
            case captureFailed
            case galleryPhotoLoaded(imageData: Foundation.Data)
            case cameraSwitched
            case uploadFailed

            public static func == (lhs: Self, rhs: Self) -> Bool {
                switch (lhs, rhs) {
                case (.setupCaptureSessionCompleted(let lhs), .setupCaptureSessionCompleted(let rhs)):
                    return lhs === rhs
                    
                case (.captureCompleted(let lhs), .captureCompleted(let rhs)):
                    return lhs == rhs
                    
                case (.captureFailed, .captureFailed):
                    return true
                    
                case (.galleryPhotoLoaded(let lhs), .galleryPhotoLoaded(let rhs)):
                    return lhs == rhs
                    
                case (.cameraSwitched, .cameraSwitched):
                    return true
                    
                case (.uploadFailed, .uploadFailed):
                    return true
                    
                default:
                    return false
                }
            }
        }

        // MARK: - Presentation (프레젠테이션 관련)
        public enum Presentation: Equatable {
            case showToast(TXToastType)
        }

        // MARK: - Delegate (부모에게 알림)
        /// ProofPhoto 화면에서 외부로 전달하는 이벤트입니다.
        public enum Delegate {
            case closeProofPhoto
            case completedUploadPhoto(
                myPhotoLog: GoalDetail.CompletedGoal.PhotoLog,
                editedImageData: Foundation.Data?
            )
        }

        case view(View)
        case `internal`(Internal)
        case presentation(Presentation)
        case delegate(Delegate)
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
        BindingReducer()
        reducer
    }
}
