//
//  TXCalendar.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// 주간/월간 그리드를 제공하는 캘린더 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXCalendar(
///     mode: .monthly,
///     weeks: weeks
/// ) { item in
///     print(item.dateComponents as Any)
/// }
/// ```
public struct TXCalendar: View {
    /// 캘린더 표시 모드입니다.
    public enum DisplayMode {
        case weekly
        case monthly
    }
    
    /// 캘린더 레이아웃 설정입니다.
    public struct Configuration {
        let weeklyHorizontalPadding: CGFloat
        let monthlyHorizontalPadding: CGFloat
        let weeklyHeaderSpacing: CGFloat
        let monthlyHeaderSpacing: CGFloat
        let monthlyRowSpacing: CGFloat
        let weekdayTypography: TypographyToken
        let weekdayColor: Color
        let backgroundColor: Color
        let dateStyle: TXCalendarDateStyle
        
        public init(
            weeklyHorizontalPadding: CGFloat = Spacing.spacing6,
            monthlyHorizontalPadding: CGFloat = Spacing.spacing7,
            weeklyHeaderSpacing: CGFloat = Spacing.spacing4,
            monthlyHeaderSpacing: CGFloat = Spacing.spacing8,
            monthlyRowSpacing: CGFloat = Spacing.spacing6,
            weekdayTypography: TypographyToken = .c1_12r,
            weekdayColor: Color = Color.Gray.gray300,
            backgroundColor: Color = Color.Common.white,
            dateStyle: TXCalendarDateStyle = .init()
        ) {
            self.weeklyHorizontalPadding = weeklyHorizontalPadding
            self.monthlyHorizontalPadding = monthlyHorizontalPadding
            self.weeklyHeaderSpacing = weeklyHeaderSpacing
            self.monthlyHeaderSpacing = monthlyHeaderSpacing
            self.monthlyRowSpacing = monthlyRowSpacing
            self.weekdayTypography = weekdayTypography
            self.weekdayColor = weekdayColor
            self.backgroundColor = backgroundColor
            self.dateStyle = dateStyle
        }
    }
    
    public static let defaultWeekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    private let mode: DisplayMode
    private let weekdays: [String]
    private let weeks: [[TXCalendarDateItem]]
    private let config: Configuration
    private let onSelect: (TXCalendarDateItem) -> Void
    
    public init(
        mode: DisplayMode,
        weeks: [[TXCalendarDateItem]],
        weekdays: [String] = TXCalendar.defaultWeekdays,
        config: Configuration = .init(),
        onSelect: @escaping (TXCalendarDateItem) -> Void = { _ in }
    ) {
        self.mode = mode
        self.weeks = weeks
        self.weekdays = Array(weekdays.prefix(TXCalendarLayout.daysInWeek))
        self.config = config
        self.onSelect = onSelect
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let spacing = TXCalendarLayout.columnSpacing(
                availableWidth: proxy.size.width,
                horizontalPadding: horizontalPadding,
                cellSize: config.dateStyle.size,
                columns: TXCalendarLayout.daysInWeek
            )
            
            VStack(spacing: headerSpacing) {
                weekdayRow(spacing: spacing)
                
                if mode == .weekly {
                    weekRow(spacing: spacing)
                } else {
                    monthGrid(spacing: spacing)
                }
            }
            .padding(
                .horizontal,
                horizontalPadding
            )
            .frame(
                width: proxy.size.width,
                height: contentHeight,
                alignment: .top
            )
            .background(config.backgroundColor)
        }
        .frame(height: contentHeight)
    }
}

// MARK: - SubViews
private extension TXCalendar {
    func weekdayRow(spacing: CGFloat) -> some View {
        HStack(spacing: spacing) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .typography(config.weekdayTypography)
                    .foregroundStyle(config.weekdayColor)
                    .frame(width: config.dateStyle.size)
            }
        }
    }
    
    func weekRow(spacing: CGFloat) -> some View {
        HStack(spacing: spacing) {
            ForEach(weekDateItems) { item in
                dateButton(for: item)
            }
        }
    }
    
    func monthGrid(spacing: CGFloat) -> some View {
        let columns = TXCalendarLayout.gridColumns(
            cellSize: config.dateStyle.size,
            spacing: spacing,
            columns: TXCalendarLayout.daysInWeek
        )
        
        return LazyVGrid(
            columns: columns,
            spacing: config.monthlyRowSpacing
        ) {
            ForEach(monthDateItems) { item in
                dateButton(for: item)
            }
        }
    }
    
    func dateButton(for item: TXCalendarDateItem) -> some View {
        Button {
            onSelect(item)
        } label: {
            TXCalendarDateCell(item: item, style: config.dateStyle)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Helpers
private extension TXCalendar {
    var headerSpacing: CGFloat {
        switch mode {
        case .weekly:
            return config.weeklyHeaderSpacing
            
        case .monthly:
            return config.monthlyHeaderSpacing
        }
    }
    
    var horizontalPadding: CGFloat {
        switch mode {
        case .weekly:
            return config.weeklyHorizontalPadding
            
        case .monthly:
            return config.monthlyHorizontalPadding
        }
    }
    
    var contentHeight: CGFloat {
        let headerHeight = TXCalendarLayout.weekdayLabelHeight(config.weekdayTypography)
        let headerSectionHeight = headerHeight + headerSpacing
        
        switch mode {
        case .weekly:
            return headerSectionHeight + config.dateStyle.size
            
        case .monthly:
            return headerSectionHeight + monthGridHeight
        }
    }
    
    var monthGridHeight: CGFloat {
        guard !weeks.isEmpty else {
            return 0
        }
        
        let rowCount = CGFloat(weeks.count)
        let rowSpacing = config.monthlyRowSpacing * CGFloat(weeks.count - 1)
        return (config.dateStyle.size * rowCount) + rowSpacing
    }
    
    var weekDateItems: [TXCalendarDateItem] {
        weeks.first ?? []
    }
    
    var monthDateItems: [TXCalendarDateItem] {
        weeks.flatMap { $0 }
    }
}
