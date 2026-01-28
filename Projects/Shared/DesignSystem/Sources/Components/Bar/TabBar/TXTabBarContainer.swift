//
//  TXTabBarContainer.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// 하단 탭바와 콘텐츠를 함께 관리하는 컨테이너입니다.
///
/// ## 사용 예시
/// ```swift
/// struct MainTabView: View {
///     @State private var selectedTab: TXTabItem = .home
///
///     var body: some View {
///         TXTabBarContainer(selectedItem: $selectedTab) {
///             switch selectedTab {
///             case .home:
///                 HomeView()
///             case .statistics:
///                 StatisticsView()
///             case .couple:
///                 CoupleView()
///             }
///         }
///     }
/// }
/// ```
public struct TXTabBarContainer<Content: View>: View {
    @Binding private var selectedItem: TXTabItem
    private let isTabBarHidden: Bool
    private let content: () -> Content

    public init(
        selectedItem: Binding<TXTabItem>,
        isTabBarHidden: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selectedItem = selectedItem
        self.isTabBarHidden = isTabBarHidden
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            content()
            if !isTabBarHidden {
                TXTabBar(selectedItem: $selectedItem)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedItem: TXTabItem = .home

        var body: some View {
            TXTabBarContainer(selectedItem: $selectedItem) {
                VStack {
                    Text("Selected: \(selectedItem.title)")
                    Spacer()
                }
            }
        }
    }

    return PreviewWrapper()
}
