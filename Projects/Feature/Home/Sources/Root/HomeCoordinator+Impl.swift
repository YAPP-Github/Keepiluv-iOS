//
//  HomeCoordinatorReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/27/26.
//

import ComposableArchitecture
import FeatureGoalDetailInterface
import FeatureProofPhotoInterface
import FeatureHomeInterface

extension HomeCoordinator {
    /// 기본 구성의 HomeCoordinatorReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = HomeCoordinatorReducer()
    /// ```
    public init(
        goalDetailReducer: GoalDetailReducer,
        proofPhotoReducer: ProofPhotoReducer
    ) {
        let reducer = Reduce<State, Action> { state, action in
            switch action {
            case .home(.delegate(.goToGoalDetail)):
                state.routes.append(.detail)
                state.goalDetail = .init()
                return .none
                
            case .goalDetail(.delegate(.navigateBack)):
                state.routes.removeLast()
                state.goalDetail = nil
                return .none
                
            case .home:
                return .none
                
            case .goalDetail:
                return .none
                
            case .binding:
                return .none
            }
        }
        
        self.init(
            reducer: reducer,
            homeReducer: HomeReducer(proofPhotoReducer: proofPhotoReducer),
            goalDetailReducer: goalDetailReducer
        )
    }
}
