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

    /// 특정 월의 캘린더 데이터를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let weeks = TXCalendarDataGenerator.generateMonthData(
    ///     year: 2026,
    ///     month: 12,
    ///     selectedDay: 14
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - year: 연도
    ///   - month: 월 (1-12)
    ///   - selectedDay: 선택된 날짜 (nil이면 선택 없음)
    /// - Returns: 주 단위로 그룹화된 날짜 아이템 배열
    public static func generateMonthData(
        year: Int,
        month: Int,
        selectedDay: Int?
    ) -> [[TXCalendarDateItem]] {
        var weeks: [[TXCalendarDateItem]] = []

        guard let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return weeks
        }

        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysInMonth = range.count

        // 이전 달 정보
        let previousMonth = month == 1 ? 12 : month - 1
        let previousYear = month == 1 ? year - 1 : year
        let daysInPreviousMonth = daysInPreviousMonth(year: previousYear, month: previousMonth)

        var currentWeek: [TXCalendarDateItem] = []
        var dayCounter = 1

        // 이전 달 날짜 채우기
        let leadingEmptyDays = firstWeekday - 1
        for idx in 0..<leadingEmptyDays {
            let day = daysInPreviousMonth - leadingEmptyDays + 1 + idx
            currentWeek.append(.init(text: "\(day)", status: .lastMonth))
        }

        // 현재 달 날짜 채우기
        while dayCounter <= daysInMonth {
            let status: TXCalendarDateStatus = (dayCounter == selectedDay) ? .selectedFilled : .default
            currentWeek.append(.init(text: "\(dayCounter)", status: status))
            dayCounter += 1

            if currentWeek.count == 7 {
                weeks.append(currentWeek)
                currentWeek = []
            }
        }

        // 다음 달 날짜로 마지막 주 채우기
        if !currentWeek.isEmpty {
            var nextMonthDay = 1
            while currentWeek.count < 7 {
                currentWeek.append(.init(text: "\(nextMonthDay)", status: .lastMonth))
                nextMonthDay += 1
            }
            weeks.append(currentWeek)
        }

        return weeks
    }
}

// MARK: - Private Helpers

private extension TXCalendarDataGenerator {
    static func daysInPreviousMonth(year: Int, month: Int) -> Int {
        guard let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return 30
        }
        return range.count
    }
}
