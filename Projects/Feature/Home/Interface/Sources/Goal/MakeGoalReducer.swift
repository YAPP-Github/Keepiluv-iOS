//
//  MakeGoalReducer.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 2/1/26.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct MakeGoalReducer {
    
    let reducer: Reduce<State, Action>
    
    @ObservableState
    public struct State: Equatable {
        public var mode: Mode
        public var category: GoalCategory
        public var goalTitle: String
        public var selectedPeriod: String?
        public var periodCount: Int
        public var isEndDateOn: Bool = false
        public var showPeriodCount: Bool {
            selectedPeriod != "매일"
        }
        public var periodCountText: String { "\(selectedPeriod ?? "") \(periodCount)번"}
        
        public enum Mode: Equatable {
            case add
            case edit
        }
        
        public init(
            category: GoalCategory,
            mode: Mode,
        ) {
            self.mode = mode
            self.category = category
            self.goalTitle = category.title
            self.selectedPeriod = category.repeatCycle.text
            self.periodCount = category.repeatCycle.count
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case emojiButtonTapped
        case periodSelected
        case startDateTapped
        case endDateTapped
        case completeButtonTapped
    }
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        reducer
    }
}
