//
//  AddGoalSheet.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/31/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHomeInterface
import FeatureMakeGoalInterface
import SharedDesignSystem

struct AddGoalListView: View {
    private let items: [GoalCategory] = GoalCategory.allCases
    
    var action: (GoalCategory) -> Void
    
    init(action: @escaping (GoalCategory) -> Void) {
        self.action = action
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerView
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                categoryListView
                    .padding(.top, 33.5)
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    AddGoalListView(action: { _ in })
}

// MARK: - SubViews
private extension AddGoalListView {
    var headerView: some View {
        // FIXME: -h4-brand-20b
        VStack(alignment: .leading, spacing: 4) {
            Text("새로운 목표 추가")
                .typography(.h4_20b)
                .foregroundStyle(Color.Gray.gray500)
                .padding(.top, 13.5)
            
            Text("함께하는 목표를 추가해 보세요!")
                .typography(.b2_14r)
                .foregroundStyle(Color.Gray.gray400)
                .padding(.top, 4)
        }
    }
    
    var categoryListView: some View {
        VStack(spacing: 16) {
            ForEach(items, id: \.self) { item in
                categoryCardView(for: item)
            }
        }
    }
    
    func categoryCardView(for item: GoalCategory) -> some View {
        CardHeaderView(
            config: .goalAdd(
                goalName: item.title,
                iconImage: item.icon,
                action: {
                    action(item)
                }
            )
        )
    }
}
