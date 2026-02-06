//
//  HomeCoordinatorReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/27/26.
//

import ComposableArchitecture
import FeatureGoalDetailInterface
import FeatureHomeInterface
import FeatureProofPhotoInterface

extension HomeCoordinator {
    /// 기본 구성의 HomeCoordinatorReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = HomeCoordinatorReducer()
    /// ```
    // swiftlint:disable:next function_body_length
    public init(
        goalDetailReducer: GoalDetailReducer,
        proofPhotoReducer: ProofPhotoReducer,
        makeGoalReducer: MakeGoalReducer
    ) {
        let reducer = Reduce<State, Action> { state, action in
            switch action {
            case .home(.delegate(.goToGoalDetail)):
                state.routes.append(.detail)
                state.goalDetail = .init()
                return .none
                
            case let .home(.delegate(.goToMakeGoal(category))):
                state.routes.append(.makeGoal)
                state.makeGoal = .init(category: category, mode: .add)
                return .none
                
            case .goalDetail(.delegate(.navigateBack)):
                state.routes.removeLast()
                return .none
                
            case .goalDetail(.onDisappear):
                state.goalDetail = nil
                return .none
                
            case .makeGoal(.delegate(.navigateBack)):
                state.routes.removeLast()
                return .none
                
            case .makeGoal(.onDisappear):
                state.makeGoal = nil
                return .none
                
            case .home:
                return .none
                
            case .goalDetail:
                return .none
                
            case .makeGoal:
                return .none
                
            case .binding:
                return .none
            }
        }
        
        self.init(
            reducer: reducer,
            homeReducer: HomeReducer(proofPhotoReducer: proofPhotoReducer),
            goalDetailReducer: goalDetailReducer,
            makeGoalReducer: makeGoalReducer
        )
    }
}
