//
//  GaolDetailReducer.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import Foundation

import ComposableArchitecture

/// GoalDetail 화면의 상태와 액션을 정의하는 리듀서입니다.
@Reducer
public struct GoalDetailReducer {
    let reducer: Reduce<State, Action>
    
    @ObservableState
    /// GoalDetail 화면 렌더링에 필요한 상태입니다.
    public struct State {
        
        /// 목표 카드의 사용자 타입을 나타냅니다.
        public enum UserType {
            case me
            case you
        }
        
        /// 목표 카드의 완료 상태를 나타냅니다.
        public enum Status {
            case completed
            case pending
        }
        
        public var item: DetailCompletedItem
        public var currentUser: UserType
        public var status: Status
        
        /// 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = GoalDetailReducer.State(
        ///     item: item,
        ///     currentUser: .me,
        ///     status: .completed
        /// )
        /// ```
        public init(
            item: DetailCompletedItem,
            currentUser: UserType,
            status: Status,
        ) {
            self.item = item
            self.currentUser = currentUser
            self.status = status
        }
    }
    
    /// GoalDetail 화면에서 발생하는 액션입니다.
    public enum Action {
        
    }
    
    /// 외부에서 주입된 Reduce로 리듀서를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = GoalDetailReducer(
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

extension GoalDetailReducer.State {
    public var isCompleted: Bool {
        status == .completed
    }
    
    public var isShowReactionBar: Bool {
        currentUser == .you && isCompleted
    }
    
    public var explainText: String {
        switch currentUser {
        case .you:
            return "\(item.name)\n님은 아직인가봐요!"
        case .me:
            return "인증샷을\n올려보세요!"
        }
    }
    
    public var nonCompleteButtonText: String {
        switch currentUser {
        case .me:
            return "업로드하기"
        case .you:
            return "찔러보세요"
        }
    }
}
