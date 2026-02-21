//
//  StatsCardView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/18/26.
//

import SwiftUI

public struct StatsCardView: View {
    
    private let item: StatsCardItem
    private let isOngoing: Bool
    private let columns = Array(
        repeating: GridItem(.flexible()),
        count: Constants.gridColumnCount
    )
    private let icon = TXVector.Icon.allCases.randomElement() ?? .clover
    
    public init(
        item: StatsCardItem,
        isOngoing: Bool
    ) {
        self.item = item
        self.isOngoing = isOngoing
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
    }
}

// MARK: - SubViews
private extension StatsCardView {
    var header: some View {
        CardHeaderView(
            config: .goalStats(
                goalName: item.goalName,
                iconImage: item.iconImage,
                goalCount: item.goalCount
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
                        let fillColor = isCompleted ? Constants.iconColors.randomElement() ?? .clear : .clear
                        let borderColor = isCompleted ? Color.Gray.gray500 : Color.Gray.gray200
                        
                        TXVector(
                            icon: icon,
                            fillColor: fillColor,
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
        static let iconColors: [Color] = [
            Color.Chromatic.blue400,
            Color.Chromatic.green400,
            Color.Chromatic.pink400,
            Color.Chromatic.yellow400,
            Color.Chromatic.orange400,
            Color.Chromatic.purple400
        ]
    }
}

#Preview {
    VStack {
        StatsCardView(
            item: .init(
                goalId: 1,
                goalName: "목표이름",
                iconImage: .Icon.Illustration.book,
                goalCount: 30,
                completionInfos: [
                    .init(name: "민정", count: 10),
                    .init(name: "현수", count: 20)
                ]
            ),
            isOngoing: true
        )
        
        StatsCardView(
            item: .init(
                goalId: 2,
                goalName: "목표이름",
                iconImage: .Icon.Illustration.book,
                goalCount: 20,
                completionInfos: [
                    .init(name: "민정", count: 3),
                    .init(name: "현수", count: 10)
                ]
            ),
            isOngoing: false
        )  
    }
    .padding(.horizontal, 20)
}
