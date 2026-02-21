//
//  StatsDetailView.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureStatsInterface
import SharedDesignSystem

struct StatsDetailView: View {
    
    let store: StoreOf<StatsDetailReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView {
                monthNavigation
                    .padding(.top, 32)
                calendar
                    .padding(.top, 12)
                statsInfoContent
                    .padding(.top, 44)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .overlay {
            if store.isLoading {
                ProgressView()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - SubViews
private extension StatsDetailView {
    var navigationBar: some View {
        TXNavigationBar(
            style: .subContent(
                .init(
                    title: store.naviBarTitle,
                    rightContent: store.isCompleted
                        ? .rotatedImage(Image.Icon.Symbol.meatball, angle: .degrees(90))
                        : .text("삭제")
                )
            )
        )
    }
    
    var monthNavigation: some View {
        TXCalendarMonthNavigation(
            title: store.currentMonthTitle,
            isPreviousDisabled: store.previousMonthDisabled,
            isNextDisabled: store.nextMonthDisabled,
            onPrevious: { store.send(.previousMonthTapped)},
            onNext: { store.send(.nextMonthTapped)}
        )
    }
    
    var calendar: some View {
        TXCalendar(
            mode: .monthly,
            weeks: store.monthlyData,
            config: .init(
                dateCellBackground: { item in
                    guard let completedDate = completedDate(for: item) else { return nil }
                    
                    return AnyView(
                        dateImageBackground(
                            myImageUrl: completedDate.myImageUrl,
                            partnerImageUrl: completedDate.partnerImageUrl
                        )
                    )
                }
            )
        )
            .padding(.vertical, 24)
            .background(Color.Common.white)
            .insideBorder(
                Color.Gray.gray500,
                shape: RoundedRectangle(cornerRadius: 16),
                lineWidth: 1
            )
            .background(alignment: .topLeading) {
                Image.Illustration.hug
                    .offset(x: 10, y: -48)
            }
            .overlay(alignment: .topTrailing) {
                Image.Illustration.plane
                    .offset(x: -7, y: -50)
            }
    }
    
    var statsInfoContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(store.statsSummaryInfo, id: \.title) { summary in
                HStack(spacing: 28) {
                    summaryTitle(for: summary.title)
                    summartyContent(content: summary.content, isCompletedCount: summary.isCompletedCount)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .insideRectEdgeBorder(width: 1, edges: [.top, .bottom], color: Color.Gray.gray500)
    }
    
    func summaryTitle(for title: String) -> some View {
        Text(title)
            .typography(.c1_12r)
            .foregroundStyle(Color.Gray.gray400)
            .frame(width: 48, alignment: .leading)
    }
    
    func summartyContent(content: [String], isCompletedCount: Bool) -> some View {
        HStack(spacing: 0) {
            if isCompletedCount {
                Image.Icon.Symbol.check
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.Gray.gray500)
                    .frame(width: 16, height: 16)
                    .padding(.trailing, 9)
            }
            
            Text(content[0])
                .typography(.b4_12b)
                .foregroundStyle(Color.Gray.gray500)
            
            if isCompletedCount {
                Text("|")
                    .typography(.b4_12b)
                    .foregroundStyle(Color.Gray.gray200)
                    .padding(.horizontal, 8)
                
                Text(content[1])
                    .typography(.b4_12b)
                    .foregroundStyle(Color.Gray.gray500)
            }
        }
    }
    
    @ViewBuilder
    func dateImageBackground(
        myImageUrl: String?,
        partnerImageUrl: String?
    ) -> some View {
        let bothCompleted: Bool = myImageUrl != nil && partnerImageUrl != nil
        
        Group {
            if let myImageUrl,
               let partnerImageUrl {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color.Common.white)
                        .insideBorder(
                            Color.Gray.gray500,
                            shape: RoundedRectangle(cornerRadius: 7),
                            lineWidth: 1.2
                        )
                        .rotationEffect(.degrees(16))
                    
                    SharedDesignSystemAsset.ImageAssets.girl.swiftUIImage
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                }
            } else if let myImageUrl {
                SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 7))
            } else if let partnerImageUrl {
                SharedDesignSystemAsset.ImageAssets.girl.swiftUIImage
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 7))
            }
        }
        .insideBorder(
            bothCompleted ? Color.Common.white : Color.Gray.gray500,
            shape: RoundedRectangle(cornerRadius: 7),
            lineWidth: 1.2
        )
    }
}

// MARK: - Private Methods
private extension StatsDetailView {
    func completedDate(for item: TXCalendarDateItem) -> (myImageUrl: String?, partnerImageUrl: String?)? {
        guard item.status == .completed,
              let components = item.dateComponents,
              let dateKey = TXCalendarDate(components: components)?.formattedAPIDateString() else {
            return nil
        }
        
        guard let completedDate = store.completedDateByKey[dateKey] else { return nil }
        return (completedDate.myImageUrl, completedDate.partnerImageUrl)
    }
}

#Preview {
    StatsDetailView(
        store: Store(
            initialState: StatsDetailReducer.State(goalId: 1),
            reducer: { StatsDetailReducer() }
        )
    )
}
