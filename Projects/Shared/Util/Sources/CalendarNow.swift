//
//  CalendarNow.swift
//
//
//  Created by Jihun on 01/27/26.
//

import Foundation

/// 현재 날짜의 년/월/일 정보를 제공합니다.
public struct CalendarNow: Equatable, Hashable {
    public let year: Int
    public let month: Int
    public let day: Int

    public init(
        date: Date = Date(),
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) {
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }

    public var monthTitleKorean: String {
        "\(month)월\(year)"
    }
}
