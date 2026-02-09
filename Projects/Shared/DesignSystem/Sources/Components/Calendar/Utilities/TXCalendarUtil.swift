//
//  CalendarUtil.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/6/26.
//

import Foundation

/// 캘린더 관련 공통 유틸리티입니다.
///
/// ## 사용 예시
/// ```swift
/// let lhs = TXCalendarDate(year: 2026, month: 2, day: 1)
/// let rhs = TXCalendarDate(year: 2026, month: 2, day: 6)
/// let isEarlier = TXCalendarUtil.isEarlier(lhs, than: rhs)
/// ```
public enum TXCalendarUtil {
    /// 두 날짜의 선후를 비교합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let lhs = TXCalendarDate(year: 2026, month: 2, day: 1)
    /// let rhs = TXCalendarDate(year: 2026, month: 2, day: 6)
    /// let isEarlier = TXCalendarUtil.isEarlier(lhs, than: rhs)
    /// ```
    public static func isEarlier(_ lhs: TXCalendarDate, than rhs: TXCalendarDate) -> Bool {
        guard let lhsDate = lhs.date, let rhsDate = rhs.date else { return false }
        return lhsDate < rhsDate
    }
    
    public static func apiDateString(for component: TXCalendarDate) -> String {
        let yearString = String(format: "%04d", component.year)
        let monthString = String(format: "%02d", component.month)
        let dayString = String(format: "%02d", component.day ?? 1)
        return "\(yearString)-\(monthString)-\(dayString)"
    }

    /// API 날짜 문자열(YYYY-MM-DD)을 TXCalendarDate로 변환합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let date = TXCalendarUtil.parseAPIDateString("2026-02-08")
    /// ```
    public static func parseAPIDateString(_ dateString: String) -> TXCalendarDate? {
        let components = dateString.split(separator: "-")
        guard components.count == 3,
              let year = Int(components[0]),
              let month = Int(components[1]),
              let day = Int(components[2]) else {
            return nil
        }
        return TXCalendarDate(year: year, month: month, day: day)
    }
}
