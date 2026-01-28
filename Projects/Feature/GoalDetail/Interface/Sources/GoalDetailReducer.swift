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

/// GoalDetail 화면의 상태와 액션을 정의하는 리듀서입니다.
@Reducer
public struct GoalDetailReducer {
    private let reducer: Reduce<State, Action>
    private let proofPhotoReducer: ProofPhotoReducer
    
    /// GoalDetail 화면 렌더링에 필요한 상태입니다.
    @ObservableState
    public struct State {
        public var item: GoalDetail?
        public var currentUser: GoalDetail.Owner = .mySelf
        public var currentCard: GoalDetail.CompletedGoal? {
            let index = currentUser == .mySelf ? 0 : 1
            return item?.completedGoal[index]
        }
        public var isCompleted: Bool { currentCard?.image == nil }
        public var comment: String { currentCard?.coment ?? "" }
        public var createdAt: String { currentCard?.createdAt ?? "" }
        
        public var proofPhoto: ProofPhotoReducer.State?
        public var isPresentedProofPhoto: Bool = false
        
        
        public var isShowReactionBar: Bool { currentUser == .you && isCompleted }
        public var isLoading: Bool { item == nil }
        
        public init() {
        }
    }
    
    /// GoalDetail 화면에서 발생하는 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // MARK: - LifeCycle
        case onAppear
        
        // MARK: - Action
        case bottomButtonTapped
        
        // MARK: - State Update
        case authorizationCompleted(isAuthorized: Bool)
        case fethedGoalDetailItem(GoalDetail)
        case proofPhotoDismissed
        
        // MARK: - Reducer
        case proofPhoto(ProofPhotoReducer.Action)
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
            return "민정\n님은 아직인가봐요!"
            
        case .mySelf:
            return "인증샷을\n올려보세요!"
        }
    }
    
    public var nonCompleteButtonText: String {
        switch currentUser {
        case .mySelf:
            return "업로드하기"
            
        case .you:
            return "찔러보세요"
        }
    }
}
