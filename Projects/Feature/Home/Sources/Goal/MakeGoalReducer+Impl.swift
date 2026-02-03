//
//  MakeGoalReducer+Impl.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 2/1/26.
//

import Foundation

import ComposableArchitecture
import FeatureHomeInterface

extension MakeGoalReducer {
    public init() {
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                
                // MARK: - LifeCycle
            case .onDisappear:
                return .none
                
                // MARK: - User Action
            case .emojiButtonTapped:
                return .none
                
            case .periodSelected:
                state.isPeriodSheetPresented = true
                return .none

            case .periodSheetWeeklyTapped:
                state.selectedPeriod = .weekly(count: state.weeklyPeriodCount)
                return .none

            case .periodSheetMonthlyTapped:
                state.selectedPeriod = .monthly(count: state.monthlyPeriodCount)
                return .none

            case .periodSheetMinusTapped:
                switch state.selectedPeriod {
                case .daily:
                    return .none
                    
                case .weekly:
                    state.weeklyPeriodCount -= 1
                    state.selectedPeriod = .weekly(count: state.weeklyPeriodCount)
                    
                case .monthly:
                    state.monthlyPeriodCount -= 1
                    state.selectedPeriod = .monthly(count: state.monthlyPeriodCount)
                }
                
                return .none
                
            case .periodSheetPlusTapped:
                switch state.selectedPeriod {
                case .daily:
                    return .none
                    
                case .weekly:
                    state.weeklyPeriodCount += 1
                    state.selectedPeriod = .weekly(count: state.weeklyPeriodCount)
                    
                case .monthly:
                    state.monthlyPeriodCount += 1
                    state.selectedPeriod = .monthly(count: state.monthlyPeriodCount)
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
                state.calendarSheetDate = state.endDate
                state.isCalendarSheetPresented = true
                return .none
                
            case .monthCalendarConfirmTapped:
                guard let target = state.calendarTarget else {
                    state.isCalendarSheetPresented = false
                    return .none
                }
                
                switch target {
                case .startDate:
                    state.startDate = state.calendarSheetDate
                case .endDate:
                    state.endDate = state.calendarSheetDate
                }
                
                state.isCalendarSheetPresented = false
                return .none
                
            case .completeButtonTapped:
                // FIXME: - POST
                return .send(.delegate(.navigateBack))
                
            case .navigationBackButtonTapped:
                return .send(.delegate(.navigateBack))
                
            case .delegate:
                return .none

            case .binding:
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}
