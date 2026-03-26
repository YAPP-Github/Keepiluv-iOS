//
//  StatsCardView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/18/26.
//

import SwiftUI

/// 목표별 스탬프 통계 정보를 카드 형태로 보여주는 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// StatsCardView(
///     item: item,
///     isOngoing: true,
///     onTap: { goalId in
///         print(goalId)
///     }
/// )
/// ```
public struct StatsCardView: View {
    
    private let item: StatsCardItem
    private let isOngoing: Bool
    private let columns = Array(
        repeating: GridItem(.flexible()),
        count: Constants.gridColumnCount
    )
    
    private var onTap: (Int64) -> Void
    
    /// 통계 카드 구성값과 탭 액션을 받아 컴포넌트를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = StatsCardView(
    ///     item: item,
    ///     isOngoing: false,
    ///     onTap: { _ in }
    /// )
    /// ```
    public init(
        item: StatsCardItem,
        isOngoing: Bool,
        onTap: @escaping (Int64) -> Void
    ) {
        self.item = item
        self.isOngoing = isOngoing
        self.onTap = onTap
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            header
            horizontalDivider
            completionSection
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
        .outsideBorder(
            Color.Gray.gray500,
            shape: RoundedRectangle(cornerRadius: Constants.cardCornerRadius),
            lineWidth: Constants.borderLineWidth
        )
        .onTapGesture { onTap(item.goalId) }
    }
}

// MARK: - SubViews
private extension StatsCardView {
    var header: some View {
        CardHeaderView(
            config: .goalStats(
                goalName: item.goalName,
                iconImage: item.iconImage,
                goalCount: item.goalCount,
                isOngoing: isOngoing,
                onHeaderTapped: { onTap(item.goalId) }
            )
        )
    }
    
    var horizontalDivider: some View {
        Color.Gray.gray500
            .frame(maxWidth: .infinity, maxHeight: Constants.borderLineWidth)
    }
    
    var completionSection: some View {
        HStack(spacing: 0) {
            ForEach(Array(item.completionInfos.enumerated()), id: \.offset) { index, info in
                completionCell(info: info)
                    .overlay(alignment: .trailing) {
                        if index < item.completionInfos.count - 1 {
                            verticalDivider
                        }
                    }
            }
        }
        .background(Color.Common.white)
    }
    
    func completionCell(info: StatsCardItem.CompletionInfo) -> some View {
        VStack(spacing: Constants.cellVerticalSpacing) {
            HStack(spacing: 0) {
                Text(info.name)
                    .typography(.b4_12b)
                    .foregroundStyle(Color.Gray.gray400)
                
                Spacer()
                
                Text("\(info.count)번 완료")
                    .typography(.b4_12b)
                    .foregroundStyle(Color.Gray.gray400)
            }
            
            if isOngoing {
                LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
                    ForEach(0..<item.goalCount, id: \.self) { count in
                        let isCompleted = count < info.count
                        let stampColor = isCompleted
                        ? info.stampColors.color(at: count) ?? Color.Chromatic.blue400
                        : .clear
                        let borderColor = isCompleted ? Color.Gray.gray500 : Color.Gray.gray200
                        
                        TXVector(
                            icon: item.stampIcon,
                            fillColor: stampColor,
                            borderColor: borderColor
                        )
                        .frame(
                            width: Constants.iconSize,
                            height: Constants.iconSize
                        )
                    }
                }
            }
        }
        .padding(Constants.cellPadding)
    }
    
    var verticalDivider: some View {
        Color.Gray.gray500
            .frame(width: Constants.borderLineWidth)
    }
}

private extension Array where Element == StatsCardItem.StampColor {
    func color(at index: Int) -> Color? {
        guard indices.contains(index) else { return nil }
        return self[index].color
    }
}

private extension StatsCardItem.StampColor {
    var color: Color {
        switch self {
        case .green400:
            return Color.Chromatic.green400
        case .blue400:
            return Color.Chromatic.blue400
        case .yellow400:
            return Color.Chromatic.yellow400
        case .pink400:
            return Color.Chromatic.pink400
        case .pink300:
            return Color.Chromatic.pink300
        case .pink200:
            return Color.Chromatic.pink200
        case .orange400:
            return Color.Chromatic.orange400
        case .purple400:
            return Color.Chromatic.purple400
        }
    }
}

// MARK: - Constants
private extension StatsCardView {
    enum Constants {
        static let gridColumnCount = 7
        static let cardCornerRadius: CGFloat = 12
        static let borderLineWidth: CGFloat = 1
        static let cellVerticalSpacing: CGFloat = 12
        static let gridSpacing: CGFloat = 4
        static let iconSize: CGFloat = 18
        static let cellPadding: CGFloat = 16
    }
}

#Preview {
    VStack {
        StatsCardView(
            item: .init(
                goalId: 1,
                goalName: "목표이름",
                iconImage: .Icon.Illustration.book,
                stampIcon: .clover,
                goalCount: 30,
                completionInfos: [
                    .init(name: "민정", count: 10, stampColors: [.green400, .blue400]),
                    .init(name: "현수", count: 20, stampColors: [.pink400, .orange400])
                ]
            ),
            isOngoing: true,
            onTap: { _ in }
        )
        
        StatsCardView(
            item: .init(
                goalId: 2,
                goalName: "목표이름",
                iconImage: .Icon.Illustration.book,
                stampIcon: .flower,
                goalCount: 20,
                completionInfos: [
                    .init(name: "민정", count: 3, stampColors: []),
                    .init(name: "현수", count: 10, stampColors: [])
                ]
            ),
            isOngoing: false,
            onTap: { _ in }
        )
    }
    .padding(.horizontal, 20)
}
