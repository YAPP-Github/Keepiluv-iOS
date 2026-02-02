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
                
                // MARK: - User Action
            case .emojiButtonTapped:
                return .none
                
            case .periodSelected:
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
                return .none
                
            case .binding:
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}
