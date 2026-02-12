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
import DomainPhotoLogInterface
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
        @Dependency(\.photoLogClient) var photoLogClient
        
        // swiftlint:disable:next closure_body_length
        let reducer = Reduce<State, Action> { state, action in
            
            switch action {
                // MARK: - Life Cycle
            case .onAppear:
                if state.calendarDate.day == nil {
                    let now = state.nowDate
                    let date = TXCalendarDate(
                        year: now.year,
                        month: now.month,
                        day: now.day
                    )
                    return .send(.setCalendarDate(date))
                }
                state.isLoading = true
                return .send(.fetchGoals)
                
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
                    if date == state.calendarDate {
                        state.isLoading = true
                        return .send(.fetchGoals)
                    }
                    return .send(.setCalendarDate(date))
                    
                case .subTitleTapped:
                    return .send(.setCalendarSheetPresented(true))
                    
                case .alertTapped:
                    return .none
                    
                case .settingTapped:
                    return .send(.delegate(.goToSettings))
                    
                case .backTapped,
                        .rightTapped,
                        .closeTapped:
                    return .none
                }
                
            case .monthCalendarConfirmTapped:
                state.isCalendarSheetPresented = false
                return .send(.setCalendarDate(state.calendarSheetDate))
                
            case let .goalCheckButtonTapped(id, isChecked):
                if isChecked {
                    guard let card = state.cards.first(where: { $0.id == id }),
                          let photologId = card.myCard.photologId else {
                        return .none
                    }
                    state.pendingDeleteGoalID = id
                    state.pendingDeletePhotologID = photologId
                    state.modal = .info(.uncheckGoal)
                    return .none
                } else {
                    return .run { send in
                        let isAuthorized = await captureSessionClient.fetchIsAuthorized()
                        await send(.authorizationCompleted(id: id, isAuthorized: isAuthorized))
                    }
                }
                
            case .modalConfirmTapped:
                guard let pendingGoalID = state.pendingDeleteGoalID,
                      let pendingPhotologID = state.pendingDeletePhotologID else {
                    return .none
                }
                state.pendingDeleteGoalID = nil
                state.pendingDeletePhotologID = nil
                return .run { send in
                    do {
                        try await photoLogClient.deletePhotoLog(pendingPhotologID)
                        await send(.deletePhotoLogCompleted(goalId: pendingGoalID))
                    } catch {
                        await send(.deletePhotoLogFailed)
                    }
                }
                
            case let .yourCardTapped(card):
                if !card.yourCard.isSelected {
                    return .send(.showToast(.poke(message: "상대방을 찔렀어요!")))
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
                return .send(.delegate(.goToEditGoalList(date: state.calendarDate)))
                
            case let .weekCalendarSwipe(swipe):
                switch swipe {
                case .next:
                    guard let nextWeekDate = TXCalendarUtil.dateByAddingWeek(
                        from: state.calendarDate,
                        by: 1
                    ) else {
                        return .none
                    }
                    return .send(.setCalendarDate(nextWeekDate))
                    
                case .previous:
                    guard let previousWeekDate = TXCalendarUtil.dateByAddingWeek(
                        from: state.calendarDate,
                        by: -1
                    ) else {
                        return .none
                    }
                    return .send(.setCalendarDate(previousWeekDate))
                }
                
                // MARK: - Update State
            case let .fetchGoalsCompleted(items, date):
                if date != state.calendarDate {
                    return .none
                }
                state.isLoading = false
                if state.cards != items {
                    state.cards = items
                }
                return .none

            case .fetchGoalsFailed:
                state.isLoading = false
                return .send(.showToast(.warning(message: "목표 조회에 실패했어요")))
                
            case let .setCalendarDate(date):
                let now = state.nowDate
                if date == state.calendarDate {
                    return .none
                }
                state.calendarDate = date
                state.calendarMonthTitle = "\(date.month)월 \(date.year)"
                state.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: date)
                state.isRefreshHidden = (
                    date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day
                )
                state.isLoading = true
                return .send(.fetchGoals)
                
            case .fetchGoals:
                let date = state.calendarDate
                return .run { send in
                    do {
                        let goals = try await goalClient.fetchGoals(TXCalendarUtil.apiDateString(for: date))
                        let items: [GoalCardItem] = goals.map { goal in
                            let myImageURL = goal.myVerification?.imageURL.flatMap(URL.init(string:))
                            let yourImageURL = goal.yourVerification?.imageURL.flatMap(URL.init(string:))
                            return GoalCardItem(
                                id: goal.id,
                                goalName: goal.title,
                                goalEmoji: goal.goalIcon.image,
                                myCard: .init(
                                    photologId: goal.myVerification?.photologId,
                                    imageURL: myImageURL,
                                    isSelected: goal.myVerification?.isCompleted ?? false,
                                    emoji: goal.myVerification?.emoji?.image
                                ),
                                yourCard: .init(
                                    photologId: goal.yourVerification?.photologId,
                                    imageURL: yourImageURL,
                                    isSelected: goal.yourVerification?.isCompleted ?? false,
                                    emoji: goal.yourVerification?.emoji?.image
                                )
                            )
                        }
                        await send(.fetchGoalsCompleted(items, date: date))
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
                
            case let .proofPhoto(.delegate(.completedUploadPhoto(myPhotoLog, _))):
                state.isProofPhotoPresented = false
                guard let goalId = state.proofPhoto?.goalId else { return .none }
                guard let index = state.cards.firstIndex(where: { $0.id == goalId }) else { return .none }
                let imageURL = myPhotoLog.imageUrl.flatMap(URL.init(string:))
                state.cards[index].myCard = .init(
                    photologId: myPhotoLog.photologId,
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

            case let .deletePhotoLogCompleted(goalId):
                guard let index = state.cards.firstIndex(where: { $0.id == goalId }) else {
                    return .none
                }
                state.cards[index].myCard = .init(
                    photologId: nil,
                    imageURL: nil,
                    isSelected: false,
                    emoji: state.cards[index].myCard.emoji
                )
                return .send(.showToast(.delete(message: "인증이 해제되었어요")))

            case .deletePhotoLogFailed:
                return .send(.showToast(.warning(message: "해제에 실패했어요")))

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
