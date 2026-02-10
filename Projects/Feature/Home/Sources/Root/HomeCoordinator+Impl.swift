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
import FeatureSettingsInterface

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
        makeGoalReducer: MakeGoalReducer,
        editGoalListReducer: EditGoalListReducer,
        settingsReducer: SettingsReducer
    ) {
        let reducer = Reduce<State, Action> { state, action in
            switch action {
            case let .home(.delegate(.goToGoalDetail(id, owner, verificationDate))):
                state.routes.append(.detail)
                state.goalDetail = .init(currentUser: owner, id: id, verificationDate: verificationDate)
                return .none
                
            case let .home(.delegate(.goToMakeGoal(category))):
                state.routes.append(.makeGoal)
                state.makeGoal = .init(category: category, mode: .add)
                return .none
                
            case let .home(.delegate(.goToEditGoalList(date))):
                state.routes.append(.editGoalList)
                state.editGoalList = .init(calendarDate: date)
                return .none

            case .home(.delegate(.goToSettings)):
                state.settings = .init()
                state.isSettingsPresented = true
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
                
            case .editGoalList(.delegate(.navigateBack)):
                state.editGoalList = nil
                state.routes.removeLast()
                return .none
                
            case let .editGoalList(.delegate(.goToGoalEdit(goalId))):
                state.routes.append(.makeGoal)
                state.makeGoal = .init(category: .custom, mode: .edit, editingGoalId: goalId)
                return .none
                
            case .home:
                return .none
                
            case .goalDetail:
                return .none
                
            case .makeGoal:
                return .none
                
            case .editGoalList:
                return .none

            case .settings(.delegate(.navigateBack)):
                state.isSettingsPresented = false
                return .none

            case .settings(.delegate(.logoutCompleted)):
                state.isSettingsPresented = false
                return .send(.delegate(.logoutCompleted))

            case .settings(.delegate(.withdrawCompleted)):
                state.isSettingsPresented = false
                return .send(.delegate(.withdrawCompleted))

            case .settings(.delegate(.sessionExpired)):
                state.isSettingsPresented = false
                return .send(.delegate(.sessionExpired))

            case .settingsDismissed:
                state.settings = nil
                return .none

            case .settings:
                return .none

            case .delegate:
                return .none

            case .binding:
                return .none
            }
        }
        
        self.init(
            reducer: reducer,
            homeReducer: HomeReducer(proofPhotoReducer: proofPhotoReducer),
            goalDetailReducer: goalDetailReducer,
            makeGoalReducer: makeGoalReducer,
            editGoalListReducer: editGoalListReducer,
            settingsReducer: settingsReducer
        )
    }
}
