//
//  TXCalendarDataGenerator.swift
//  SharedDesignSystem
//
//  Created by Claude on 1/26/26.
//

import Foundation

/// 캘린더 데이터 생성 유틸리티입니다.
public enum TXCalendarDataGenerator {
    private static let calendar = Calendar(identifier: .gregorian)

    /// TXCalendarDate를 사용하여 특정 월의 캘린더 데이터를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let date = TXCalendarDate(year: 2026, month: 12, day: 14)
    /// let weeks = TXCalendarDataGenerator.generateMonthData(for: date)
    /// ```
    ///
    /// - Parameter date: 캘린더 날짜
    /// - Returns: 주 단위로 그룹화된 날짜 아이템 배열
    public static func generateMonthData(for date: TXCalendarDate) -> [[TXCalendarDateItem]] {
        guard let context = MonthContext(year: date.year, month: date.month, calendar: calendar) else {
            return []
        }
        return buildWeeks(context: context, selectedDay: date.day)
    }
}

// MARK: - Month Context

private extension TXCalendarDataGenerator {
    struct MonthContext {
        let year: Int
        let month: Int
        let daysInMonth: Int
        let firstWeekday: Int
        let daysInPreviousMonth: Int

        init?(year: Int, month: Int, calendar: Calendar) {
            guard let firstDay = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
                  let range = calendar.range(of: .day, in: .month, for: firstDay) else {
                return nil
            }

            self.year = year
            self.month = month
            self.daysInMonth = range.count
            self.firstWeekday = calendar.component(.weekday, from: firstDay)

            let prevMonth = month == 1 ? 12 : month - 1
            let prevYear = month == 1 ? year - 1 : year
            self.daysInPreviousMonth = Self.daysIn(year: prevYear, month: prevMonth, calendar: calendar)
        }

        private static func daysIn(year: Int, month: Int, calendar: Calendar) -> Int {
            guard let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
                  let range = calendar.range(of: .day, in: .month, for: date) else {
                return 30
            }
            return range.count
        }
    }
}

// MARK: - Week Building

private extension TXCalendarDataGenerator {
    static func buildWeeks(context: MonthContext, selectedDay: Int?) -> [[TXCalendarDateItem]] {
        var weeks: [[TXCalendarDateItem]] = []
        var currentWeek = makeLeadingItems(context: context)

        for day in 1...context.daysInMonth {
            let status: TXCalendarDateStatus = (day == selectedDay) ? .selectedFilled : .default
            currentWeek.append(.init(text: "\(day)", status: status))

            if currentWeek.count == 7 {
                weeks.append(currentWeek)
                currentWeek = []
            }
        }

        if !currentWeek.isEmpty {
            appendTrailingItems(to: &currentWeek)
            weeks.append(currentWeek)
        }

        return weeks
    }

    static func makeLeadingItems(context: MonthContext) -> [TXCalendarDateItem] {
        let leadingCount = context.firstWeekday - 1
        guard leadingCount > 0 else { return [] }

        return (0..<leadingCount).map { idx in
            let day = context.daysInPreviousMonth - leadingCount + 1 + idx
            return .init(text: "\(day)", status: .lastMonth)
        }
    }

    static func appendTrailingItems(to week: inout [TXCalendarDateItem]) {
        var nextDay = 1
        while week.count < 7 {
            week.append(.init(text: "\(nextDay)", status: .lastMonth))
            nextDay += 1
        }
    }
}
