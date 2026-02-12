//
//  GaolDetailReducer.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

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
        public let goalId: Int64
        public var item: GoalDetail?
        public var currentGoalIndex: Int = 0
        public var currentUser: GoalDetail.Owner
        public let verificationDate: String
        
        public var completedGoalItems: [GoalDetail.CompletedGoal] {
            item?.completedGoals.compactMap { $0 } ?? []
        }
        
        public var currentCompletedGoal: GoalDetail.CompletedGoal? {
            guard completedGoalItems.indices.contains(currentGoalIndex) else { return nil }
            return completedGoalItems[currentGoalIndex]
        }
        
        public var currentCard: GoalDetail.CompletedGoal.PhotoLog? {
            switch currentUser {
            case .mySelf:
                return currentCompletedGoal?.myPhotoLog
                
            case .you:
                return currentCompletedGoal?.yourPhotoLog
            }
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
            ?? goalId
        }
        
        public var canSwipeUp: Bool { currentGoalIndex + 1 < completedGoalItems.count }
        public var canSwipeDown: Bool { currentGoalIndex > 0 }
        
        public var isCompleted: Bool {
            pendingEditedImageData != nil || currentCard?.imageUrl != nil
        }
        public var comment: String { currentCard?.comment ?? "" }
        public var naviBarRightText: String {
            if case .mySelf = currentUser, isCompleted {
                return isEditing ? "저장" : "수정"
            } else {
                return ""
            }
        }
        
        public var proofPhoto: ProofPhotoReducer.State?
        public var isPresentedProofPhoto: Bool = false
        public var isCameraPermissionAlertPresented: Bool = false
        
        public var selectedReactionEmoji: ReactionEmoji?
        public var isShowReactionBar: Bool { currentUser == .you && isCompleted }
        public var isLoading: Bool { item == nil }
        public var isEditing: Bool = false
        public var isSavingPhotoLog: Bool = false
        public var pendingEditedImageData: Data?
        public var commentText: String = ""
        public var isCommentFocused: Bool = false
        public var toast: TXToastType?
        public var createdAt: String = ""
        
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
            self.currentUser = currentUser
            self.goalId = id
            self.verificationDate = verificationDate
        }
    }
    
    /// GoalDetail 화면에서 발생하는 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // MARK: - LifeCycle
        case onAppear
        case onDisappear
        
        // MARK: - Action
        case bottomButtonTapped
        case navigationBarTapped(TXNavigationBar.Action)
        case reactionEmojiTapped(ReactionEmoji)
        case cardTapped
        case cardSwipedUp
        case cardSwipedDown
        case focusChanged(Bool)
        case dimmedBackgroundTapped
        case updateMyPhotoLog(GoalDetail.CompletedGoal.PhotoLog)
        
        // MARK: - State Update
        case authorizationCompleted(isAuthorized: Bool)
        case fethedGoalDetailItem(GoalDetail)
        case fetchGoalDetailFailed
        case updateCurrentCardReaction(Goal.Reaction?)
        case reactionUpdateFailed(previousReaction: Goal.Reaction?)
        case showToast(TXToastType)
        case setCreatedAt(String)
        case proofPhotoDismissed
        case cameraPermissionAlertDismissed
        case updatePhotoLog
        
        // MARK: - Child Action
        case proofPhoto(ProofPhotoReducer.Action)
        
        // MARK: - Delegate
        case delegate(Delegate)
        
        /// GoalDetail 화면에서 외부로 전달하는 이벤트입니다.
        public enum Delegate {
            case navigateBack
        }
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
            .ifLet(\.proofPhoto, action: \.proofPhoto) {
                proofPhotoReducer
            }
    }
}

extension GoalDetailReducer.State {
    public var explainText: String {
        switch currentUser {
        case .you:
            guard let nickname = item?.partnerNickname else { return "" }
            return "\(nickname)\n님은 아직인가봐요!"
            
        case .mySelf:
            return "인증샷을\n올려보세요!"
        }
    }
    
    public var bottomButtonText: String {
        switch currentUser {
        case .mySelf:
            return isEditing ? "다시 찍기" : "업로드하기"
            
        case .you:
            return "찔러보세요"
        }
    }
}
