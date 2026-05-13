//
//  MakeGoal.swift
//  FeatureMakeGoal
//
//  Created by 정지훈 on 5/12/26.
//

import Foundation

import DomainCommonInterface
import SharedDesignSystem
import SharedUtil

public extension MakeGoalReducer.State {
    public struct MakeGoal: Equatable {
        public var goalId: Int64?
        public var category: GoalCategory
        public var icon: GoalIcon
        public var title: String
        public var repeatCycle: RepeatCycle
        public var startDate: TXCalendarDate
        public var endDate: TXCalendarDate
        public var isEndDateOn: Bool = false
        public var weeklyPeriodCount: Int
        public var monthlyPeriodCount: Int
        
        public init(
            goalId: Int64? = nil,
            category: GoalCategory,
            icon: GoalIcon? = nil,
            title: String?,
            repeatCycle: RepeatCycle? = nil,
            startDate: String?,
            endDate: String?,
            weeklyPeriodCount: Int = 1,
            monthlyPeriodCount: Int = 1
        ) {
            let now = CalendarNow()
            let today = TXCalendarDate(
                year: now.year,
                month: now.month,
                day: now.day
            )
            
            self.goalId = goalId
            self.category = category
            self.icon = icon ?? GoalIcon.allCases[category.iconIndex]
            self.title = title ?? category.title
            self.repeatCycle = repeatCycle ?? category.repeatCycle
            
            if let startDateString = startDate,
               let startDate = TXCalendarUtil.parseAPIDateString(startDateString) {
                self.startDate = startDate
            } else {
                self.startDate = today
            }
            
            if let endDateString = endDate,
               let endDate = TXCalendarUtil.parseAPIDateString(endDateString) {
                self.endDate = endDate
                self.isEndDateOn = true
            } else {
                self.endDate = self.startDate
            }
            self.weeklyPeriodCount = weeklyPeriodCount
            self.monthlyPeriodCount = monthlyPeriodCount
        }
    }
}
