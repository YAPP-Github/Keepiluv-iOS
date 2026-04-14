//
//  GaolDetailReducer.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import DomainGoalInterface
import FeatureProofPhotoInterface
import SharedDesignSystem

/// GoalDetail 화면의 상태와 액션을 정의하는 리듀서입니다.
@Reducer
public struct GoalDetailReducer {
    private let reducer: Reduce<State, Action>
    private let proofPhotoReducer: ProofPhotoReducer

    /// GoalDetail 화면 렌더링에 필요한 상태입니다.
    @ObservableState
    public struct State: Equatable {

        // MARK: - Nested Structs

        /// 도메인 데이터
        public struct Data: Equatable {
            public let goalId: Int64
            public let verificationDate: String
            public var item: GoalDetail?
            public var currentGoalIndex: Int = 0
            public var currentUser: GoalDetail.Owner
            public var selectedReactionEmoji: ReactionEmoji?
            public var pendingEditedImageData: Foundation.Data?
            public var commentText: String = ""
            public var createdAt: String = ""

            public init(
                goalId: Int64,
                verificationDate: String,
                currentUser: GoalDetail.Owner
            ) {
                self.goalId = goalId
                self.verificationDate = verificationDate
                self.currentUser = currentUser
            }
        }

        /// UI 상태
        public struct UIState: Equatable {
            public var isSwapped: Bool = false
            public var isEditing: Bool = false
            public var isSavingPhotoLog: Bool = false
            public var isCommentFocused: Bool = false

            public init() {}
        }

        /// 프레젠테이션
        public struct Presentation: Equatable {
            public var proofPhoto: ProofPhotoReducer.State?
            public var isPresentedProofPhoto: Bool = false
            public var isCameraPermissionAlertPresented: Bool = false
            public var toast: TXToastType?

            public init() {}
        }

        // MARK: - State Instances

        public var data: Data
        public var ui: UIState
        public var presentation: Presentation

        // MARK: - Computed Properties

        public var completedGoalItems: [GoalDetail.CompletedGoal] {
            data.item?.completedGoals.compactMap { $0 } ?? []
        }

        public var currentCompletedGoal: GoalDetail.CompletedGoal? {
            guard completedGoalItems.indices.contains(data.currentGoalIndex) else { return nil }
            return completedGoalItems[data.currentGoalIndex]
        }

        public var currentCard: GoalDetail.CompletedGoal.PhotoLog? {
            isFrontMyCard ? currentCompletedGoal?.myPhotoLog : currentCompletedGoal?.yourPhotoLog
        }

        public var myCard: GoalDetail.CompletedGoal.PhotoLog? {
            currentCompletedGoal?.myPhotoLog
        }

        public var partnerCard: GoalDetail.CompletedGoal.PhotoLog? {
            currentCompletedGoal?.yourPhotoLog
        }

        public var currentEditedImageData: Foundation.Data? {
            isFrontMyCard ? data.pendingEditedImageData : nil
        }

        public var myCardEditedImageData: Foundation.Data? {
            data.pendingEditedImageData
        }

        public var myCardImageURL: String? {
            myCard?.imageUrl
        }

        public var partnerCardImageURL: String? {
            partnerCard?.imageUrl
        }

        public var myCardComment: String {
            myCard?.comment ?? ""
        }

        public var partnerCardComment: String {
            partnerCard?.comment ?? ""
        }

        public var myCardIsCompleted: Bool {
            myCardEditedImageData != nil || myCardImageURL != nil
        }

        public var partnerCardIsCompleted: Bool {
            partnerCardImageURL != nil
        }

        public var goalName: String {
            if let goalName = currentCompletedGoal?.goalName, !goalName.isEmpty {
                return goalName
            }
            let myPhotoLog = currentCompletedGoal?.myPhotoLog
            let yourPhotoLog = currentCompletedGoal?.yourPhotoLog
            return myPhotoLog?.goalName ?? yourPhotoLog?.goalName ?? ""
        }

        public var currentGoalId: Int64 {
            currentCompletedGoal?.myPhotoLog?.goalId
            ?? currentCompletedGoal?.yourPhotoLog?.goalId
            ?? data.goalId
        }

        public var isCompleted: Bool {
            currentEditedImageData != nil || currentCard?.imageUrl != nil
        }

        public var comment: String { currentCard?.comment ?? "" }

        public var naviBarRightText: String {
            if isFrontMyCard, isCompleted {
                return ui.isEditing ? "저장" : "수정"
            } else {
                return ""
            }
        }

        public var myHasEmoji: Bool { isFrontMyCard && data.selectedReactionEmoji != nil }
        public var isShowReactionBar: Bool { !isFrontMyCard && isCompleted }
        public var isLoading: Bool { data.item == nil }
        public var isFrontMyCard: Bool { data.currentUser == .mySelf }

        /// 기본 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = GoalDetailReducer.State(
        ///     currentUser: .mySelf,
        ///     id: 1,
        ///     verificationDate: "2026-02-07"
        /// )
        /// ```
        public init(
            currentUser: GoalDetail.Owner,
            id: Int64,
            verificationDate: String
        ) {
            self.data = Data(goalId: id, verificationDate: verificationDate, currentUser: currentUser)
            self.ui = UIState()
            self.presentation = Presentation()
        }
    }

    /// GoalDetail 화면에서 발생하는 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - View (사용자 이벤트)
        public enum View: Equatable {
            case bottomButtonTapped
            case navigationBarTapped(TXNavigationBar.Action)
            case reactionEmojiTapped(ReactionEmoji)
            case cardSwiped
            case focusChanged(Bool)
            case dimmedBackgroundTapped
            case proofPhotoDismissed
            case cameraPermissionAlertDismissed
        }

        // MARK: - Internal (Reducer 내부 Effect)
        public enum Internal: Equatable {
            case onAppear
            case onDisappear
            case updateMyPhotoLog(GoalDetail.CompletedGoal.PhotoLog)
            case updatePhotoLog
        }

        // MARK: - Response (비동기 응답)
        public enum Response: Equatable {
            case authorizationCompleted(isAuthorized: Bool)
            case fethedGoalDetailItem(GoalDetail)
            case fetchGoalDetailFailed
            case updateCurrentCardReaction(String?)
            case reactionUpdateFailed(previousReaction: String?)
            case setCreatedAt(String)
        }

        // MARK: - Presentation (프레젠테이션 관련)
        public enum Presentation: Equatable {
            case showToast(TXToastType)
        }

        // MARK: - Delegate (부모에게 알림)
        /// GoalDetail 화면에서 외부로 전달하는 이벤트입니다.
        public enum Delegate {
            case navigateBack
        }

        // MARK: - Child Action
        case proofPhoto(ProofPhotoReducer.Action)

        case view(View)
        case `internal`(Internal)
        case response(Response)
        case presentation(Presentation)
        case delegate(Delegate)
    }

    /// 외부에서 주입된 Reduce와 ProofPhotoReducer로 리듀서를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = GoalDetailReducer(
    ///     reducer: Reduce { _, _ in .none },
    ///     proofPhotoReducer: ProofPhotoReducer()
    /// )
    /// ```
    public init(
        reducer: Reduce<State, Action>,
        proofPhotoReducer: ProofPhotoReducer
    ) {
        self.reducer = reducer
        self.proofPhotoReducer = proofPhotoReducer
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        reducer
            .ifLet(\.presentation.proofPhoto, action: \.proofPhoto) {
                proofPhotoReducer
            }
    }
}

extension GoalDetailReducer.State {
    public var partnerEmptyText: String {
        guard let nickname = data.item?.partnerNickname else { return "" }
        return "\(nickname)\n님은 아직인가봐요!"
    }

    public var explainText: String {
        !isFrontMyCard ? partnerEmptyText : "인증샷을\n올려보세요!"
    }

    public var bottomButtonText: String {
        switch isFrontMyCard {
        case true:
            return ui.isEditing ? "다시 찍기" : "업로드하기"
        case false:
            return "찌르기"
        }
    }
}
