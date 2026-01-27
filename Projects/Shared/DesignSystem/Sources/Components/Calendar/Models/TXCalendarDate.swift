//
//  TXCalendarDate.swift
//  SharedDesignSystem
//
//  Created by Claude on 1/26/26.
//

import Foundation

/// 캘린더에서 사용하는 날짜 상태입니다.
///
/// year, month, day를 통합 관리하며 월 이동 등의 연산을 제공합니다.
///
/// ## 사용 예시
/// ```swift
/// @State private var date = TXCalendarDate(year: 2026, month: 12)
///
/// // 월 이동
/// date.goToNextMonth()
/// date.goToPreviousMonth()
///
/// // 날짜 선택
/// date.day = 14
/// ```
public struct TXCalendarDate: Equatable, Hashable {
    public var year: Int
    public var month: Int
    public var day: Int?

    public init(year: Int, month: Int, day: Int? = nil) {
        self.year = year
        self.month = month
        self.day = day
    }

    /// 현재 날짜로 초기화합니다.
    public init() {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        self.year = calendar.component(.year, from: now)
        self.month = calendar.component(.month, from: now)
        self.day = nil
    }

    /// DateComponents로 변환합니다.
    public var dateComponents: DateComponents {
        DateComponents(year: year, month: month, day: day)
    }

    /// Date로 변환합니다. day가 nil이면 해당 월의 1일을 반환합니다.
    public var date: Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day ?? 1
        return Calendar(identifier: .gregorian).date(from: components)
    }

    /// 포맷된 문자열을 반환합니다. (예: "2026.12")
    public var formattedYearMonth: String {
        String(format: "%d.%02d", year, month)
    }

    /// 다음 달로 이동합니다.
    public mutating func goToNextMonth() {
        if month == 12 {
            month = 1
            year += 1
        } else {
            month += 1
        }
        day = nil
    }

    /// 이전 달로 이동합니다.
    public mutating func goToPreviousMonth() {
        if month == 1 {
            month = 12
            year -= 1
        } else {
            month -= 1
        }
        day = nil
    }

    /// 특정 날짜를 선택합니다.
    public mutating func selectDay(_ day: Int?) {
        self.day = day
    }
}
