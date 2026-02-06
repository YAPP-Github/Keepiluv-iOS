//
//  TXGridButtonModalContent.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/4/26.
//

import SwiftUI

/// 아이콘 선택 그리드를 표시하는 모달 콘텐츠입니다.
public struct TXGridButtonModalContent: View {

    /// 아이콘 선택 그리드 콘텐츠의 표시 구성을 정의합니다.
    public struct Configuration: Equatable {
        let title: String
        let icons: [Image]
        var selectedIndex: Int
        let buttonTitle: String
        let gridCount: Int
        let imageSize: CGSize
        let frameSize: CGSize

        /// 아이콘 선택 모달 콘텐츠를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// TXGridButtonModalContent(
        ///     config: .selectIcon(selectedIndex: 1),
        ///     selectedIndex: .constant(1)
        /// )
        /// ```
        public init(
            title: String,
            icons: [Image],
            selectedIndex: Int,
            buttonTitle: String,
            gridCount: Int,
            imageSize: CGSize,
            frameSize: CGSize
        ) {
            self.title = title
            self.icons = icons
            self.selectedIndex = selectedIndex
            self.buttonTitle = buttonTitle
            self.gridCount = gridCount
            self.imageSize = imageSize
            self.frameSize = frameSize
        }
    }

    private let config: Configuration
    @Binding private var selectedIndex: Int
    
    /// 아이콘 선택 그리드 모달 콘텐츠를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXGridButtonModalContent(
    ///     config: .selectIcon(icons: [.Icon.Illustration.book], selectedIndex: 0),
    ///     selectedIndex: .constant(0)
    /// )
    /// ```
    public init(
        config: Configuration,
        selectedIndex: Binding<Int>
    ) {
        self.config = config
        self._selectedIndex = selectedIndex
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text(config.title)
                .typography(.t1_18eb)
                .padding(.top, Spacing.spacing9)
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible()),
                    count: config.gridCount
                ),
                spacing: Spacing.spacing7
            ) {
                ForEach(Array(config.icons.enumerated()), id: \.offset) { index, icon in
                    Button {
                        selectedIndex = index
                    } label: {
                        icon
                            .resizable()
                            .frame(width: config.imageSize.width, height: config.imageSize.height)
                            .frame(width: config.frameSize.width, height: config.frameSize.height)
                            .background(Color.Gray.gray50, in: Circle())
                            .insideBorder(
                                selectedIndex == index ? Color.Gray.gray500 : Color.Gray.gray100,
                                shape: .circle,
                                lineWidth: LineWidth.m
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, Spacing.spacing7)
            .padding(.horizontal, Spacing.spacing8)
        }
    }
}
