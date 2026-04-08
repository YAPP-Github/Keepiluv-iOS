//
//  CardHeaderView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

/// 카드 헤더 영역을 구성하는 뷰입니다.
///
/// ## 사용 예시
/// ```swift
/// CardHeaderView(
///     title: "목표 이름",
///     iconImage: .Icon.Illustration.exercise,
///     isBordered: true,
///     onTap: { }
/// ) {
///     TXCheckButton(
///         isMyChecked: isMyChecked,
///         isCoupleChecked: false,
///         action: { }
///     )
/// }
/// ```
public struct CardHeaderView<R: View>: View {
    
    private let title: String
    private let iconImage: Image
    private let rightContent: R
    private let isBordered: Bool
    private let onTap: (() -> Void)?
    
    public init(
        title: String,
        iconImage: Image,
        isBordered: Bool,
        onTap: (() -> Void)?,
        @ViewBuilder rightContent: () -> R
    ) {
        self.title = title
        self.iconImage = iconImage
        self.rightContent = rightContent()
        self.isBordered = isBordered
        self.onTap = onTap
    }
    
    public var body: some View {
        if isBordered {
            borderCard
        } else {
            nonBorderCard
        }
    }
}

// MARK: - SubViews
private extension CardHeaderView {
    var borderCard: some View {
        baseContent
            .clipShape(RoundedRectangle(cornerRadius: Constants.radius))
            .outsideBorder(
                Constants.borderColor,
                shape: RoundedRectangle(cornerRadius: Constants.radius),
                lineWidth: Constants.borderWidth
            )
    }
    
    var nonBorderCard: some View {
        baseContent
            .insideRectEdgeBorder(
                width: Constants.borderWidth,
                edges: [.bottom],
                color: Constants.borderColor
            )
    }
    
    var baseContent: some View {
        HStack(spacing: Constants.defaultContentSpacing) {
            HStack(spacing: Constants.defaultContentSpacing) {
                iconImage
                    .resizable()
                    .frame(
                        width: Constants.iconSize,
                        height: Constants.iconSize
                    )
                
                Text(title)
                    .typography(Constants.typography)
                    .lineLimit(1)
                    .padding(.trailing, Constants.titleTrailingPadding)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            rightContent
        }
        .padding(Constants.defaultPadding)
        .background(Constants.backgroundColor)
        .onTapGesture {
            onTap?()
        }
    }
}

// MARK: - Constants
private enum Constants {
    static let iconSize: CGFloat = 32
    static let titleTrailingPadding: CGFloat = 2
    static let defaultPadding = Spacing.spacing7
    static let defaultContentSpacing = Spacing.spacing6
    static let radius = Radius.s
    static let borderColor = Color.Gray.gray500
    static let borderWidth = LineWidth.m
    static let typography = TypographyToken.t2_16b
    static let backgroundColor = Color.Common.white
}
