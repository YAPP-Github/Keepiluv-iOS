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
    /// - Parameters:
    ///   - date: 캘린더 날짜
    ///   - hideAdjacentDates: 이전/다음 달 날짜를 숨길지 여부
    /// - Returns: 주 단위로 그룹화된 날짜 아이템 배열
    public static func generateMonthData(
        for date: TXCalendarDate,
        hideAdjacentDates: Bool = false
    ) -> [[TXCalendarDateItem]] {
        guard let context = MonthContext(year: date.year, month: date.month, calendar: calendar) else {
            return []
        }
        return buildWeeks(
            context: context,
            selectedDay: date.day,
            hideAdjacentDates: hideAdjacentDates
        )
    }

    /// TXCalendarDate를 사용하여 특정 주의 캘린더 데이터를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let date = TXCalendarDate(year: 2026, month: 12, day: 14)
    /// let week = TXCalendarDataGenerator.generateWeekData(for: date)
    /// let nextWeek = TXCalendarDataGenerator.generateWeekData(for: date, weekOffset: 1)
    /// let prevWeek = TXCalendarDataGenerator.generateWeekData(for: date, weekOffset: -1)
    /// ```
    ///
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - weekOffset: 기준 주에서 이동할 주 단위 오프셋 (예: 다음 주 1, 저번 주 -1)
    /// - Returns: 주 단위로 그룹화된 날짜 아이템 배열
    public static func generateWeekData(
        for date: TXCalendarDate,
        weekOffset: Int = 0
    ) -> [[TXCalendarDateItem]] {
        guard let baseDate = date.date,
              let targetDate = dateByAddingWeeks(to: baseDate, offset: weekOffset),
              let interval = calendar.dateInterval(of: .weekOfYear, for: targetDate) else {
            return []
        }

        let selectedComponents = calendar.dateComponents([.year, .month, .day], from: targetDate)
        let items = buildWeekItems(
            startDate: interval.start,
            selectedComponents: selectedComponents
        )
        return [items]
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
    static func buildWeeks(
        context: MonthContext,
        selectedDay: Int?,
        hideAdjacentDates: Bool
    ) -> [[TXCalendarDateItem]] {
        var weeks: [[TXCalendarDateItem]] = []
        var currentWeek = makeLeadingItems(
            context: context,
            hideAdjacentDates: hideAdjacentDates
        )

        for day in 1...context.daysInMonth {
            let status: TXCalendarDateStatus = (day == selectedDay) ? .selectedFilled : .default
            let components = DateComponents(year: context.year, month: context.month, day: day)
            currentWeek.append(.init(text: "\(day)", status: status, dateComponents: components))

            if currentWeek.count == 7 {
                weeks.append(currentWeek)
                currentWeek = []
            }
        }

        if !currentWeek.isEmpty {
            appendTrailingItems(
                to: &currentWeek,
                hideAdjacentDates: hideAdjacentDates
            )
            weeks.append(currentWeek)
        }

        return weeks
    }

    static func makeLeadingItems(
        context: MonthContext,
        hideAdjacentDates: Bool
    ) -> [TXCalendarDateItem] {
        let leadingCount = context.firstWeekday - 1
        guard leadingCount > 0 else { return [] }

        return (0..<leadingCount).map { idx in
            let day = context.daysInPreviousMonth - leadingCount + 1 + idx
            if hideAdjacentDates {
                return .init(text: "", status: .default, dateComponents: nil)
            }
            return .init(text: "\(day)", status: .lastDate)
        }
    }

    static func appendTrailingItems(
        to week: inout [TXCalendarDateItem],
        hideAdjacentDates: Bool
    ) {
        var nextDay = 1
        while week.count < 7 {
            if hideAdjacentDates {
                week.append(.init(text: "", status: .default, dateComponents: nil))
            } else {
                week.append(.init(text: "\(nextDay)", status: .lastDate))
            }
            nextDay += 1
        }
    }
}

// MARK: - Week Helpers
private extension TXCalendarDataGenerator {
    static func dateByAddingWeeks(to date: Date, offset: Int) -> Date? {
        calendar.date(byAdding: .weekOfYear, value: offset, to: date) ?? date
    }

    static func buildWeekItems(
        startDate: Date,
        selectedComponents: DateComponents
    ) -> [TXCalendarDateItem] {
        let referenceMonth = selectedComponents.month
        return (0..<TXCalendarLayout.daysInWeek).compactMap { offset in
            guard let dayDate = calendar.date(byAdding: .day, value: offset, to: startDate) else {
                return nil
            }
            let components = calendar.dateComponents([.year, .month, .day], from: dayDate)
            let status = weekItemStatus(
                components: components,
                selectedComponents: selectedComponents,
                referenceMonth: referenceMonth
            )
            let text = components.day.map(String.init) ?? ""
            return .init(
                text: text,
                status: status,
                dateComponents: components
            )
        }
    }

    static func weekItemStatus(
        components: DateComponents,
        selectedComponents: DateComponents,
        referenceMonth: Int?
    ) -> TXCalendarDateStatus {
        let isSelected = components.year == selectedComponents.year
            && components.month == selectedComponents.month
            && components.day == selectedComponents.day
        if isSelected { return .selectedLine }
        if referenceMonth != components.month { return .lastDate }
        return .default
    }
}
