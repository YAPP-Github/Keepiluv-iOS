//
//  MakeGoalReducer+Impl.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 2/1/26.
//

import Foundation

import ComposableArchitecture
import DomainGoalInterface
import FeatureHomeInterface
import SharedDesignSystem

extension MakeGoalReducer {
    // swiftlint:disable:next function_body_length
    public init() {
        @Dependency(\.goalClient) var goalClient
        // swiftlint:disable:next closure_body_length
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                // MARK: - LifeCycle
            case .onDisappear:
                return .none
                
                // MARK: - User Action
            case .emojiButtonTapped:
                state.modal =  .gridButton(
                    .selectIcon(
                        icons: state.icons.map { $0.image },
                        selectedIndex: state.selectedEmojiIndex
                    )
                )
                return .none
                
            case let .modalConfirmTapped(index):
                state.selectedEmojiIndex = index
                return .none
                
            case .periodSelected:
                state.isPeriodSheetPresented = true
                return .none
                
            case .periodSheetWeeklyTapped:
                state.selectedPeriod = .weekly
                return .none
                
            case .periodSheetMonthlyTapped:
                state.selectedPeriod = .monthly
                return .none
                
            case .periodSheetMinusTapped:
                switch state.selectedPeriod {
                case .daily:
                    return .none
                    
                case .weekly:
                    state.weeklyPeriodCount -= 1
                    state.selectedPeriod = .weekly
                    
                case .monthly:
                    state.monthlyPeriodCount -= 1
                    state.selectedPeriod = .monthly
                }
                
                return .none
                
            case .periodSheetPlusTapped:
                switch state.selectedPeriod {
                case .daily:
                    return .none
                    
                case .weekly:
                    state.weeklyPeriodCount += 1
                    state.selectedPeriod = .weekly
                    
                case .monthly:
                    state.monthlyPeriodCount += 1
                    state.selectedPeriod = .monthly
                }
                
                return .none
                
            case .periodSheetCompleteTapped:
                state.isPeriodSheetPresented = false
                return .none
                
            case .startDateTapped:
                state.calendarTarget = .startDate
                state.calendarSheetDate = state.startDate
                state.isCalendarSheetPresented = true
                return .none
                
            case .endDateTapped:
                state.calendarTarget = .endDate
                if TXCalendarUtil.isEarlier(state.endDate, than: state.startDate) {
                    state.endDate = state.startDate
                }
                state.calendarSheetDate = state.endDate
                state.isCalendarSheetPresented = true
                return .send(.updateDateText)
                
            case .monthCalendarConfirmTapped:
                guard let target = state.calendarTarget else {
                    state.isCalendarSheetPresented = false
                    return .none
                }
                
                switch target {
                case .startDate:
                    state.startDate = state.calendarSheetDate
                    if TXCalendarUtil.isEarlier(state.endDate, than: state.startDate) {
                        state.endDate = state.startDate
                    }
                    
                case .endDate:
                    state.endDate = state.calendarSheetDate
                }
                
                state.isCalendarSheetPresented = false
                return .send(.updateDateText)
                
            case .completeButtonTapped:
                let request = GoalCreateRequestDTO(
                    name: state.goalTitle,
                    icon: state.selectedEmoji.rawValue,
                    repeatCycle: state.selectedPeriod.rawValue,
                    repeatCount: state.periodCount,
                    startDate: TXCalendarUtil.apiDateString(for: state.startDate),
                    endDate: TXCalendarUtil.apiDateString(for: state.endDate)
                )
                return .run { send in
                    
                    do {
                        _ = try await goalClient.createGoal(request)
                        await send(.delegate(.navigateBack))
                    } catch {
                        
                    }
                }
                
            case .navigationBackButtonTapped:
                return .send(.delegate(.navigateBack))

            case .updateDateText:
                guard let startDay = state.startDate.day,
                      let endDay = state.endDate.day
                else { return .none}
                
                state.startDateText = "\(state.startDate.month)월 \(startDay)일"
                state.endDateText = "\(state.endDate.month)월 \(endDay)일"
                return .none

            case .delegate:
                return .none

            case .binding:
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}
