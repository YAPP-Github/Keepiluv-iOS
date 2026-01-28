//
//  HomeReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation

import ComposableArchitecture
import DomainGoalInterface
import FeatureHomeInterface
import SharedDesignSystem
import SharedUtil

extension HomeReducer {
    /// 실제 로직을 포함한 HomeReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = HomeReducer()
    /// ```
    public init() {
        @Dependency(\.goalClient) var goalClient
        
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
                return .run { send in
                    await send(.setCalendarDate(date))
                    let myGoals = try await goalClient.fetchGoals()
                    let yourGoals = try await goalClient.fetchGoals().shuffled()
                    
                    let items = zip(myGoals, yourGoals).map { myGoal, yourGoal in
                        GoalCardItem(
                            id: myGoal.id,
                            goalName: myGoal.title,
                            goalEmoji: myGoal.goalIcon,
                            myCard: .init(
                                image: myGoal.image,
                                emoji: myGoal.emoji,
                                isSelected: myGoal.isCompleted
                            ),
                            yourCard: .init(
                                image: yourGoal.image,
                                emoji: yourGoal.emoji,
                                isSelected: yourGoal.isCompleted
                            )
                        )
                    }
                    
                    await send(.fetchGoalsCompleted(items))
                }
                
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
                    return .none
                    
                case .backTapped, .closeTapped:
                    return .none
                }
                
            case .monthCalendarConfirmTapped:
                state.isCalendarSheetPresented = false
                return .send(.setCalendarDate(state.calendarSheetDate))
                
            case let .goalCheckButtonTapped(id, isChecked):
                if isChecked {
                    state.pendingDeleteGoalID = id
                    state.modal = .deleteGoal
                    return .none
                }
                return .none
                
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
                    return .send(.path(.goToGoalDetail))
                }
                
            case .myCardTapped:
                return .send(.path(.goToGoalDetail))
                
                // MARK: - Update State
            case let .fetchGoalsCompleted(items):
                state.isLoading = false
                state.cards = items
                return .none
                
            case let .setCalendarDate(date):
                let now = state.nowDate
                state.calendarDate = date
                state.calendarMonthTitle = "\(date.month)월\(date.year)"
                state.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: date)
                state.isRefreshHidden = (
                    date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day
                )
                return .none
                
            case let .showToast(toast):
                state.toast = toast
                return .none

            case .binding:
                return .none
                
            case .path:
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}
