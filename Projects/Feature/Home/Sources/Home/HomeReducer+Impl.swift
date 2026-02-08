//
//  HomeReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import CoreCaptureSessionInterface
import DomainGoalInterface
import FeatureHomeInterface
import FeatureProofPhotoInterface
import SharedDesignSystem
import SharedUtil

extension HomeReducer {
    /// 실제 로직을 포함한 HomeReducer를 생성합니다.
    /// 
    /// ## 사용 예시
    /// ```swift
    /// let reducer = HomeReducer()
    /// ```
    
    // swiftlint:disable:next function_body_length
    public init(
        proofPhotoReducer: ProofPhotoReducer
    ) {
        @Dependency(\.goalClient) var goalClient
        @Dependency(\.captureSessionClient) var captureSessionClient
        
        // swiftlint:disable:next closure_body_length
        let reducer = Reduce<State, Action> { state, action in
            
            switch action {
                // MARK: - Life Cycle
            case .onAppear:
                let now = state.nowDate
                let date = TXCalendarDate(
                    year: now.year,
                    month: now.month,
                    day: now.day
                )
                return .send(.setCalendarDate(date))
                
                // MARK: - User Action
            case let .calendarDateSelected(item):
                guard let components = item.dateComponents,
                      let year = components.year,
                      let month = components.month,
                      let day = components.day else {
                    return .none
                }
                return .send(.setCalendarDate(TXCalendarDate(year: year, month: month, day: day)))
                
            case let .setCalendarSheetPresented(isPresented):
                state.isCalendarSheetPresented = isPresented
                if isPresented {
                    state.calendarSheetDate = state.calendarDate
                }
                return .none
                
            case let .navigationBarAction(action):
                switch action {
                case .refreshTapped:
                    let now = state.nowDate
                    let date = TXCalendarDate(
                        year: now.year,
                        month: now.month,
                        day: now.day
                    )
                    return .send(.setCalendarDate(date))
                    
                case .subTitleTapped:
                    return .send(.setCalendarSheetPresented(true))
                    
                case .alertTapped:
                    return .none
                    
                case .settingTapped:
                    return .send(.delegate(.goToSettings))
                    
                case .backTapped, .rightTapped, .closeTapped:
                    return .none
                }
                
            case .monthCalendarConfirmTapped:
                state.isCalendarSheetPresented = false
                return .send(.setCalendarDate(state.calendarSheetDate))
                
            case let .goalCheckButtonTapped(id, isChecked):
                if isChecked {
                    state.pendingDeleteGoalID = id
                    state.modal = .info(.deleteGoal)
                    return .none
                } else {
                    return .run { send in
                        let isAuthorized = await captureSessionClient.fetchIsAuthorized()
                        await send(.authorizationCompleted(id: id, isAuthorized: isAuthorized))
                    }
                }
                
            case .modalConfirmTapped:
                if let pendingID = state.pendingDeleteGoalID {
                    state.pendingDeleteGoalID = nil
                    state.cards.removeAll { $0.id == pendingID }
                    return .send(.showToast(.delete(message: "목표가 삭제되었어요")))
                }
                return .none
                
            case let .yourCardTapped(card):
                if !card.yourCard.isSelected {
                    return .send(.showToast(.poke(message: "님을 찔렀어요!")))
                } else {
                    let verificationDate = TXCalendarUtil.apiDateString(for: state.calendarDate)
                    return .send(.delegate(.goToGoalDetail(id: card.id, owner: .you, verificationDate: verificationDate)))
                }
                
            case let .myCardTapped(card):
                let verificationDate = TXCalendarUtil.apiDateString(for: state.calendarDate)
                return .send(.delegate(.goToGoalDetail(id: card.id, owner: .mySelf, verificationDate: verificationDate)))
                
            case .floatingButtonTapped:
                state.isAddGoalPresented = true
                return .none
                
            case let .addGoalButtonTapped(category):
                state.isAddGoalPresented = false
                return .send(.delegate(.goToMakeGoal(category)))
                
            case .editButtonTapped:
                return .send(.delegate(.goToEditGoalList))
                
                // MARK: - Update State
            case let .fetchGoalsCompleted(items):
                state.isLoading = false
                state.cards = items
                return .none

            case .fetchGoalsFailed:
                state.isLoading = false
                return .send(.showToast(.warning(message: "목표 조회에 실패했어요")))
                
            case let .setCalendarDate(date):
                let now = state.nowDate
                state.calendarDate = date
                state.calendarMonthTitle = "\(date.month)월 \(date.year)"
                state.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: date)
                state.isRefreshHidden = (
                    date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day
                )
                state.isLoading = true
                return .run { send in
                    do {
                        let goals = try await goalClient.fetchGoals(TXCalendarUtil.apiDateString(for: date))
                        let items: [GoalCardItem] = goals.map { goal in
                            let myImageURL = goal.myVerification.imageURL.flatMap(URL.init(string:))
                            let yourImageURL = goal.yourVerification.imageURL.flatMap(URL.init(string:))
                            return GoalCardItem(
                                id: goal.id,
                                goalName: goal.title,
                                goalEmoji: goal.goalIcon.image,
                                myCard: .init(
                                    imageURL: myImageURL,
                                    isSelected: goal.myVerification.isCompleted,
                                    emoji: goal.myVerification.emoji?.image
                                ),
                                yourCard: .init(
                                    imageURL: yourImageURL,
                                    isSelected: goal.yourVerification.isCompleted,
                                    emoji: goal.yourVerification.emoji?.image
                                )
                            )
                        }
                        await send(.fetchGoalsCompleted(items))
                    } catch {
                        await send(.fetchGoalsFailed)
                    }
                }
                
            case let .showToast(toast):
                state.toast = toast
                return .none
                
            case let .authorizationCompleted(id, isAuthorized):
                if !isAuthorized {
                    state.isCameraPermissionAlertPresented = true
                    return .none
                }
                state.proofPhoto = .init(
                    goalId: id,
                    verificationDate: TXCalendarUtil.apiDateString(for: state.calendarDate)
                )
                state.isProofPhotoPresented = true
                return .none
                
            case .cameraPermissionAlertDismissed:
                state.isCameraPermissionAlertPresented = false
                return .none
                
            case .proofPhoto(.delegate(.closeProofPhoto)):
                state.isProofPhotoPresented = false
                return .none
                
            case let .proofPhoto(.delegate(.completedUploadPhoto(completedGoal))):
                state.isProofPhotoPresented = false
                guard let goalId = state.proofPhoto?.goalId else { return .none }
                guard let index = state.cards.firstIndex(where: { $0.id == goalId }) else { return .none }
                let imageURL = completedGoal.imageUrl.flatMap(URL.init(string:))
                state.cards[index].myCard = .init(
                    imageURL: imageURL,
                    isSelected: true,
                    emoji: state.cards[index].myCard.emoji
                )
                return .none
                
            case .proofPhotoDismissed:
                state.proofPhoto = nil
                return .none
                
            case .proofPhoto:
                return .none

            case .binding:
                return .none
                
            case .delegate:
                return .none
            }
        }
        
        self.init(
            reducer: reducer,
            proofPhotoReducer: proofPhotoReducer
        )
    }
}
