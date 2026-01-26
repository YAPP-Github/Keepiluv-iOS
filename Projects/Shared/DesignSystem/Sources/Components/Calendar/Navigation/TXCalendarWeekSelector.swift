//
//  TXCalendarWeekSelector.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// 주간 날짜 선택 스트립 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXCalendarWeekSelector(items: [
///     (weekday: "일", date: .init(text: "11")),
///     (weekday: "오늘", date: .init(text: "14", status: .selectedLine))
/// ])
/// ```
public struct TXCalendarWeekSelector: View {
    /// 주간 날짜 선택 스트립 레이아웃 설정입니다.
    public struct Configuration {
        let horizontalPadding: CGFloat
        let topPadding: CGFloat
        let bottomPadding: CGFloat
        let labelSpacing: CGFloat
        let weekdayTypography: TypographyToken
        let weekdayColor: Color
        let dateStyle: TXCalendarDateStyle
        
        public init(
            horizontalPadding: CGFloat = Spacing.spacing6,
            topPadding: CGFloat = Spacing.spacing3,
            bottomPadding: CGFloat = Spacing.spacing5,
            labelSpacing: CGFloat = Spacing.spacing4,
            weekdayTypography: TypographyToken = .c1_12r,
            weekdayColor: Color = Color.Gray.gray300,
            dateStyle: TXCalendarDateStyle = .init()
        ) {
            self.horizontalPadding = horizontalPadding
            self.topPadding = topPadding
            self.bottomPadding = bottomPadding
            self.labelSpacing = labelSpacing
            self.weekdayTypography = weekdayTypography
            self.weekdayColor = weekdayColor
            self.dateStyle = dateStyle
        }
    }
    
    private let items: [(weekday: String, date: TXCalendarDateItem)]
    private let config: Configuration
    private let onSelect: (TXCalendarDateItem) -> Void
    
    public init(
        items: [(weekday: String, date: TXCalendarDateItem)],
        config: Configuration = .init(),
        onSelect: @escaping (TXCalendarDateItem) -> Void = { _ in }
    ) {
        self.items = Array(items.prefix(TXCalendarLayout.daysInWeek))
        self.config = config
        self.onSelect = onSelect
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let spacing = TXCalendarLayout.columnSpacing(
                availableWidth: proxy.size.width,
                horizontalPadding: config.horizontalPadding,
                cellSize: config.dateStyle.size,
                columns: max(items.count, 1)
            )

            HStack(spacing: spacing) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    Button {
                        onSelect(item.date)
                    } label: {
                        WeekSelectorItem(
                            weekday: item.weekday,
                            date: item.date,
                            config: config
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(EdgeInsets(
                top: config.topPadding,
                leading: config.horizontalPadding,
                bottom: config.bottomPadding,
                trailing: config.horizontalPadding
            ))
            .frame(width: proxy.size.width, height: contentHeight, alignment: .top)
        }
        .frame(height: contentHeight)
    }
}

// MARK: - SubViews
private struct WeekSelectorItem: View {
    let weekday: String
    let date: TXCalendarDateItem
    let config: TXCalendarWeekSelector.Configuration
    
    var body: some View {
        VStack(spacing: config.labelSpacing) {
            Text(weekday)
                .typography(config.weekdayTypography)
                .foregroundStyle(config.weekdayColor)
            
            TXCalendarDateCell(item: date, style: config.dateStyle)
        }
        .frame(width: config.dateStyle.size)
    }
}

// MARK: - Helpers
private extension TXCalendarWeekSelector {
    var contentHeight: CGFloat {
        let labelHeight = TXCalendarLayout.weekdayLabelHeight(config.weekdayTypography)
        let coreHeight = labelHeight + config.labelSpacing + config.dateStyle.size
        return coreHeight + config.topPadding + config.bottomPadding
    }
}
