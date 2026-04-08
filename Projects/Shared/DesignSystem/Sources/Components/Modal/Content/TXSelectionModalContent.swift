//
//  TXSelectionModalContent.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/4/26.
//

import SwiftUI

struct TXSelectionModalContent: View {
    private let title: String
    private let icons: [Image]
    @Binding private var selectedIndex: Int
    
    init(
        title: String,
        icons: [Image],
        selectedIndex: Binding<Int>
    ) {
        self.title = title
        self.icons = icons
        self._selectedIndex = selectedIndex
    }
    
    var body: some View {
        VStack(spacing: Constants.vStackSpacing) {
            Text(title)
                .typography(Constants.titleTypography)
                .padding(.top, Constants.titleTopPadding)
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible()),
                    count: Constants.gridCount
                ),
                spacing: Constants.gridSpacing
            ) {
                ForEach(Array(icons.enumerated()), id: \.offset) { index, icon in
                    Button {
                        selectedIndex = index
                    } label: {
                        icon
                            .resizable()
                            .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
                            .frame(width: Constants.frameSize.width, height: Constants.frameSize.height)
                            .insideBorder(
                                selectedIndex == index ? Color.Gray.gray500 : Color.Gray.gray100,
                                shape: .circle,
                                lineWidth: Constants.borderWidth
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, Constants.gridTopPadding)
            .padding(.horizontal, Constants.horizontalPadding)
        }
    }
}

// MARK: - Constants
private extension TXSelectionModalContent {
    enum Constants {
        static let vStackSpacing: CGFloat = 0
        static let gridCount: Int = 4
        static let imageSize = CGSize(width: 36, height: 36)
        static let frameSize = CGSize(width: 64, height: 64)
        static let titleTypography = TypographyToken.t1_18eb
        static let titleTopPadding = Spacing.spacing10
        static let gridSpacing = Spacing.spacing7
        static let gridTopPadding = Spacing.spacing7
        static let horizontalPadding = Spacing.spacing8
        static let borderWidth = LineWidth.m
    }
}
