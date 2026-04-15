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

    /// 캘린더 스와이프 방향입니다.
    public enum SwipeGesture {
        case previous
        case next
    }
    
    /// 캘린더 레이아웃 설정입니다.
    public struct Configuration {
        let weeklyHorizontalPadding: CGFloat
        let monthlyHorizontalPadding: CGFloat
        let verticalPadding: CGFloat
        let weeklyHeaderSpacing: CGFloat
        let weeklyBottomPadding: CGFloat
        let monthlyHeaderSpacing: CGFloat
        let monthlyRowSpacing: CGFloat
        let weekdayHeight: CGFloat
        let weekdayTypography: TypographyToken
        let weekdayColor: Color
        let backgroundColor: Color
        let dateStyle: TXCalendarDateStyle
        let dateCellBackground: ((TXCalendarDateItem) -> AnyView?)?
        
        /// 캘린더 레이아웃 설정을 생성합니다.
        public init(
            weeklyHorizontalPadding: CGFloat = Spacing.spacing6,
            monthlyHorizontalPadding: CGFloat = Spacing.spacing7,
            verticalPadding: CGFloat = Spacing.spacing3,
            weeklyHeaderSpacing: CGFloat = Spacing.spacing4,
            weeklyBottomPadding: CGFloat = Spacing.spacing5,
            monthlyHeaderSpacing: CGFloat = Spacing.spacing8,
            monthlyRowSpacing: CGFloat = Spacing.spacing6,
            weekdayHeight: CGFloat = 18,
            weekdayTypography: TypographyToken = .c1_12r,
            weekdayColor: Color = Color.Gray.gray300,
            backgroundColor: Color = Color.Common.white,
            dateStyle: TXCalendarDateStyle = .init(),
            dateCellBackground: ((TXCalendarDateItem) -> AnyView?)? = nil
        ) {
            self.weeklyHorizontalPadding = weeklyHorizontalPadding
            self.monthlyHorizontalPadding = monthlyHorizontalPadding
            self.verticalPadding = verticalPadding
            self.weeklyHeaderSpacing = weeklyHeaderSpacing
            self.weeklyBottomPadding = weeklyBottomPadding
            self.monthlyHeaderSpacing = monthlyHeaderSpacing
            self.monthlyRowSpacing = monthlyRowSpacing
            self.weekdayHeight = weekdayHeight
            self.weekdayTypography = weekdayTypography
            self.weekdayColor = weekdayColor
            self.backgroundColor = backgroundColor
            self.dateStyle = dateStyle
            self.dateCellBackground = dateCellBackground
        }
    }
    
    public static let defaultWeekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    private let mode: DisplayMode
    private let weekdays: [String]
    private let weeks: [[TXCalendarDateItem]]
    private let currentDate: Binding<TXCalendarDate>?
    private let canMovePrevious: Bool
    private let canMoveNext: Bool
    private let config: Configuration
    private let onSelect: (TXCalendarDateItem) -> Void
    private let onSwipe: ((SwipeGesture) -> Void)?
    @State private var weeklyScrollPosition: String?
    @State private var weeklyBaseDate: TXCalendarDate?
    
    /// 캘린더 컴포넌트를 생성합니다.
    public init(
        mode: DisplayMode,
        weeks: [[TXCalendarDateItem]],
        weekdays: [String] = Self.defaultWeekdays,
        canMovePrevious: Bool = true,
        canMoveNext: Bool = true,
        config: Configuration = .init(),
        onSelect: @escaping (TXCalendarDateItem) -> Void = { _ in },
        onSwipe: ((SwipeGesture) -> Void)? = nil

    ) {
        self.mode = mode
        self.weeks = weeks
        self.weekdays = Array(weekdays.prefix(TXCalendarLayout.daysInWeek))
        self.config = config
        self.currentDate = nil
        self.canMovePrevious = canMovePrevious
        self.canMoveNext = canMoveNext
        self.onSelect = onSelect
        self.onSwipe = onSwipe
    }

    /// 현재 날짜 바인딩을 포함한 캘린더 컴포넌트를 생성합니다.
    public init(
        mode: DisplayMode,
        currentDate: Binding<TXCalendarDate>,
        weeks: [[TXCalendarDateItem]],
        weekdays: [String] = Self.defaultWeekdays,
        config: Configuration = .init(),
        canMovePrevious: Bool = true,
        canMoveNext: Bool = true,
        onSelect: @escaping (TXCalendarDateItem) -> Void = { _ in },
        onSwipe: ((SwipeGesture) -> Void)? = nil
    ) {
        self.mode = mode
        self.weeks = weeks
        self.weekdays = Array(weekdays.prefix(TXCalendarLayout.daysInWeek))
        self.config = config
        self.currentDate = currentDate
        self.canMovePrevious = canMovePrevious
        self.canMoveNext = canMoveNext
        self.onSelect = onSelect
        self.onSwipe = onSwipe
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let spacing = TXCalendarLayout.columnSpacing(
                availableWidth: proxy.size.width,
                horizontalPadding: horizontalPadding,
                cellSize: config.dateStyle.size,
                columns: TXCalendarLayout.daysInWeek
            )

            Group {
                if mode == .weekly && weeklyReferenceDate != nil {
                    weeklyScrollableContent(
                        width: proxy.size.width,
                        spacing: spacing
                    )
                } else {
                    staticCalendarContent(
                        width: proxy.size.width,
                        spacing: spacing
                    )
                    .gesture(calendarSwipeGesture)
                }
            }
        }
        .frame(height: contentHeight)
    }
}

// MARK: - SubViews
private extension TXCalendar {
    func staticCalendarContent(width: CGFloat, spacing: CGFloat) -> some View {
        VStack(spacing: headerSpacing) {
            switch mode {
            case .weekly:
                weekdayRow(
                    items: weekDateItems,
                    spacing: spacing
                )
                weekRow(items: weekDateItems, spacing: spacing)

            case .monthly:
                monthlyWeekdayRow(spacing: spacing)
                monthGrid(spacing: spacing)
            }
        }
        .padding(.vertical, config.verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .frame(width: width, height: contentHeight, alignment: .top)
        .background(config.backgroundColor)
    }

    func weeklyScrollableContent(width: CGFloat, spacing: CGFloat) -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: spacing) {
                ForEach(weeklyDayOffsets, id: \.self) { dayOffset in
                    weeklyDayButton(
                        item: weeklyDayItem(for: dayOffset)
                    )
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, config.verticalPadding)
        }
        .scrollPosition(id: $weeklyScrollPosition, anchor: .center)
        .background(config.backgroundColor)
        .onAppear {
            if weeklyBaseDate == nil {
                weeklyBaseDate = weeklyReferenceDate
            }
            syncWeeklyScrollPosition(animated: false)
        }
        .onChange(of: weeklyReferenceDate) { _, _ in
            syncWeeklyScrollPosition(animated: true)
        }
        .frame(width: width, height: contentHeight)
    }

    func weeklyDayButton(item: TXCalendarDateItem) -> some View {
        Button {
            onSelect(item)
        } label: {
            VStack(spacing: headerSpacing) {
                Text(weeklyHeaderTitle(for: item))
                    .typography(config.weekdayTypography)
                    .foregroundStyle(config.weekdayColor)
                    .frame(width: config.dateStyle.size, height: config.weekdayHeight)

                TXCalendarDateCell(
                    item: item,
                    style: config.dateStyle,
                    customBackground: config.dateCellBackground?(item)
                )
            }
            .padding(.bottom, config.weeklyBottomPadding)
            .frame(width: config.dateStyle.size)
        }
        .buttonStyle(.plain)
        .id(dateItemScrollID(for: item))
    }

    func weekdayRow(items: [TXCalendarDateItem], spacing: CGFloat) -> some View {
        HStack(spacing: spacing) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Text(weeklyHeaderTitle(index: index, item: item))
                    .typography(config.weekdayTypography)
                    .foregroundStyle(config.weekdayColor)
                    .frame(width: config.dateStyle.size, height: config.weekdayHeight)
            }
        }
    }

    func monthlyWeekdayRow(spacing: CGFloat) -> some View {
        HStack(spacing: spacing) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .typography(config.weekdayTypography)
                    .foregroundStyle(config.weekdayColor)
                    .frame(width: config.dateStyle.size, height: config.weekdayHeight)
            }
        }
    }

    func weekRow(items: [TXCalendarDateItem], spacing: CGFloat) -> some View {
        HStack(spacing: spacing) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                dateButton(for: item)
            }
        }
    }

    func monthGrid(spacing: CGFloat) -> some View {
        Grid(
            horizontalSpacing: spacing,
            verticalSpacing: config.monthlyRowSpacing
        ) {
            ForEach(Array(weeks.enumerated()), id: \.offset) { _, week in
                GridRow {
                    ForEach(Array(week.enumerated()), id: \.offset) { _, item in
                        dateButton(for: item)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func dateButton(for item: TXCalendarDateItem) -> some View {
        let customBackground = config.dateCellBackground?(item)
        Button {
            onSelect(item)
        } label: {
            TXCalendarDateCell(
                item: item,
                style: config.dateStyle,
                customBackground: customBackground
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Helpers
private extension TXCalendar {
    var headerSpacing: CGFloat {
        switch mode {
        case .weekly: config.weeklyHeaderSpacing
        case .monthly: config.monthlyHeaderSpacing
        }
    }

    var horizontalPadding: CGFloat {
        switch mode {
        case .weekly: config.weeklyHorizontalPadding
        case .monthly: config.monthlyHorizontalPadding
        }
    }

    var contentHeight: CGFloat {
        let headerSectionHeight = config.weekdayHeight + headerSpacing
        let verticalPadding: CGFloat = config.verticalPadding * 2

        switch mode {
        case .weekly: return headerSectionHeight + config.dateStyle.size + config.weeklyBottomPadding + verticalPadding
        case .monthly: return headerSectionHeight + monthGridHeight + verticalPadding
        }
    }

    var monthGridHeight: CGFloat {
        guard !weeks.isEmpty else { return 0 }

        let rowCount = CGFloat(weeks.count)
        let rowSpacing = config.monthlyRowSpacing * CGFloat(weeks.count - 1)
        return (config.dateStyle.size * rowCount) + rowSpacing
    }

    var weekDateItems: [TXCalendarDateItem] {
        weeks.first ?? []
    }

    var weeklyReferenceDate: TXCalendarDate? {
        if let currentDate, currentDate.wrappedValue.day != nil {
            return currentDate.wrappedValue
        }
        return weeklyReferenceDateFromWeeks ?? currentDate?.wrappedValue
    }

    var weeklyReferenceDateFromWeeks: TXCalendarDate? {
        let selectedItem = weekDateItems.first { item in
            switch item.status {
            case .selectedFilled, .selectedLine:
                return item.dateComponents != nil
            case .completed, .default, .lastDate:
                return false
            }
        }

        if let selectedItem,
           let components = selectedItem.dateComponents {
            return TXCalendarDate(components: components)
        }

        guard let components = weekDateItems.compactMap(\.dateComponents).first else {
            return nil
        }
        return TXCalendarDate(components: components)
    }

    var weeklyDayOffsets: [Int] {
        Array(-365...365)
    }

    func dateItemScrollID(for item: TXCalendarDateItem) -> String? {
        guard let components = item.dateComponents,
              let year = components.year,
              let month = components.month,
              let day = components.day else {
            return nil
        }

        return "\(year)-\(month)-\(day)"
    }
}

// MARK: - Private Methods
private extension TXCalendar {
    var calendarSwipeGesture: some Gesture {
        DragGesture(minimumDistance: 16)
            .onEnded { value in
                let horizontalDistance = value.translation.width
                let verticalDistance = value.translation.height
                guard abs(horizontalDistance) > abs(verticalDistance) else { return }

                let swipe: SwipeGesture = horizontalDistance > 0 ? .previous : .next
                handleSwipe(swipe)
            }
    }

    func handleSwipe(_ swipe: SwipeGesture) {
        switch swipe {
        case .previous:
            guard canMovePrevious else { return }
        case .next:
            guard canMoveNext else { return }
        }

        applySwipeToCurrentDate(swipe)
        onSwipe?(swipe)
    }

    func weeklyDayItem(for dayOffset: Int) -> TXCalendarDateItem {
        guard let baseDate = (weeklyBaseDate ?? weeklyReferenceDate)?.date,
              let targetDate = Calendar(identifier: .gregorian).date(byAdding: .day, value: dayOffset, to: baseDate) else {
            return .init(text: "")
        }

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: targetDate)

        let itemID = "\(components.year ?? 0)-\(components.month ?? 0)-\(components.day ?? 0)"
        let isSelected = itemID == selectedDateScrollID

        let status: TXCalendarDateStatus
        if isSelected {
            status = .selectedLine
        } else if let refDate = weeklyReferenceDate, components.month != refDate.month {
            status = .lastDate
        } else {
            status = .default
        }

        return TXCalendarDateItem(
            text: components.day.map(String.init) ?? "",
            status: status,
            dateComponents: components
        )
    }

    func syncWeeklyScrollPosition(
        animated: Bool
    ) {
        guard let targetID = selectedDateScrollID else {
            return
        }

        let action = {
            weeklyScrollPosition = targetID
        }

        DispatchQueue.main.async {
            if animated {
                withAnimation(.easeInOut(duration: 0.2)) {
                    action()
                }
            } else {
                action()
            }
        }
    }

    var selectedDateScrollID: String? {
        guard let referenceDate = weeklyReferenceDate else {
            return nil
        }

        let components = referenceDate.dateComponents

        return dateItemScrollID(
            for: TXCalendarDateItem(
                text: components.day.map(String.init) ?? "",
                status: .selectedLine,
                dateComponents: components
            )
        )
    }

    func applySwipeToCurrentDate(_ swipe: SwipeGesture) {
        guard let currentDate else { return }

        var updatedDate = currentDate.wrappedValue
        switch mode {
        case .weekly:
            let offset: Int
            switch swipe {
            case .previous: offset = -1
            case .next: offset = 1
            }
            guard let date = TXCalendarUtil.dateByAddingWeek(from: updatedDate, by: offset) else { return }
            updatedDate = date

        case .monthly:
            switch swipe {
            case .previous: updatedDate.goToPreviousMonth()
            case .next: updatedDate.goToNextMonth()
            }
        }

        currentDate.wrappedValue = updatedDate
    }

    func weeklyHeaderTitle(index: Int, item: TXCalendarDateItem) -> String {
        guard let components = item.dateComponents,
              let year = components.year,
              let month = components.month,
              let day = components.day else {
            return ""
        }
        let today = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: Date())
        let isToday = today.year == year && today.month == month && today.day == day
        
        return isToday ? "오늘" : weekdays[index]
    }

    func weeklyHeaderTitle(for item: TXCalendarDateItem) -> String {
        guard let components = item.dateComponents,
              let year = components.year,
              let month = components.month,
              let day = components.day,
              let date = Calendar(identifier: .gregorian).date(from: components) else {
            return ""
        }

        let today = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: Date())
        if today.year == year && today.month == month && today.day == day {
            return "오늘"
        }

        let weekdayIndex = Calendar(identifier: .gregorian).component(.weekday, from: date) - 1
        guard weekdays.indices.contains(weekdayIndex) else {
            return ""
        }
        return weekdays[weekdayIndex]
    }
}
