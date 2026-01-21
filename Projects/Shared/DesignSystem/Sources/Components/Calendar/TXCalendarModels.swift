//
//  TXCalendarModels.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import Foundation

/// 캘린더에서 사용하는 날짜 상태입니다.
public enum TXCalendarDateStatus {
    case `default`
    case selectedLine
    case selectedFilled
    case lastMonth
}

/// 캘린더에서 사용하는 날짜 셀 데이터입니다.
///
/// ## 사용 예시
/// ```swift
/// let item = TXCalendarDateItem(
///     text: "14",
///     status: .selectedLine,
///     dateComponents: DateComponents(year: 2026, month: 12, day: 14)
/// )
/// ```
public struct TXCalendarDateItem: Identifiable, Hashable {
    public let id: UUID
    public let text: String
    public let status: TXCalendarDateStatus
    public let dateComponents: DateComponents?
    
    public init(
        id: UUID = UUID(),
        text: String,
        status: TXCalendarDateStatus = .default,
        dateComponents: DateComponents? = nil
    ) {
        self.id = id
        self.text = text
        self.status = status
        self.dateComponents = dateComponents
    }
}
