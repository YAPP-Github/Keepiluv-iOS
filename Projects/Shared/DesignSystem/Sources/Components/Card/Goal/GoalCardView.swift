//
//  GoalCardView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

/// 목표 카드 UI를 구성하는 뷰입니다.
///
/// ## 사용 예시
/// ```swift
/// GoalCardView(
///     config: .goalCheck(
///         item: .init(
///             goalName: "목표 이름",
///             goalEmoji: .Icon.Illustration.exercise,
///             myCard: .init(image: nil, emoji: nil),
///             yourCard: .init(image: nil, emoji: nil)
///         ),
///         isMyChecked: false,
///         action: { }
///     ),
///     actionLeft: { },
///     actionRight: { }
/// )
/// ```
public struct GoalCardView: View {
    
    /// GoalCardView에 필요한 스타일/데이터를 묶는 설정 값입니다.
    public struct Configuration {
        struct Placeholder {
            let image: Image
            let text: String
        }
        
        let headerConfig: CardHeaderView.Configuration
        let myItem: GoalCardItem.Card
        let yourItem: GoalCardItem.Card
        let showsContent: Bool
        let contentBackgroundColor: Color
        let borderColor: Color
        let borderWidth: CGFloat
        let cornerRadius: CGFloat
        let imageHeight: CGFloat
        let emojiSize: CGSize
        let emojiPadding: CGFloat
        let myPlaceholder: Placeholder
        let yourPlaceholder: Placeholder
        
        init(
            headerConfig: CardHeaderView.Configuration,
            myItem: GoalCardItem.Card,
            yourItem: GoalCardItem.Card,
            showsContent: Bool,
            contentBackgroundColor: Color,
            borderColor: Color,
            borderWidth: CGFloat,
            cornerRadius: CGFloat,
            imageHeight: CGFloat,
            emojiSize: CGSize,
            emojiPadding: CGFloat,
            myPlaceholder: Placeholder = .init(
                image: Image.Illustration.keepiluv,
                text: "킵잇럽!"
            ),
            yourPlaceholder: Placeholder = .init(
                image: Image.Illustration.poke,
                text: "찌르기~"
            )
        ) {
            self.headerConfig = headerConfig
            self.myItem = myItem
            self.yourItem = yourItem
            self.showsContent = showsContent
            self.contentBackgroundColor = contentBackgroundColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.cornerRadius = cornerRadius
            self.imageHeight = imageHeight
            self.emojiSize = emojiSize
            self.emojiPadding = emojiPadding
            self.myPlaceholder = myPlaceholder
            self.yourPlaceholder = yourPlaceholder
        }
    }
    
    let config: Configuration
    let actionLeft: () -> Void
    let actionRight: () -> Void
    
    /// 구성 값과 좌/우 탭 액션으로 GoalCardView를 생성합니다.
    public init(
        config: Configuration,
        actionLeft: @escaping () -> Void,
        actionRight: @escaping () -> Void
    ) {
        self.config = config
        self.actionLeft = actionLeft
        self.actionRight = actionRight
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            CardHeaderView(
                config: config.headerConfig
            )
            
            if config.showsContent {
                HStack(spacing: 0) {
                    myContent
                    yourContent
                }
                .background(config.contentBackgroundColor)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
        .outsideBorder(
            config.borderColor,
            shape: RoundedRectangle(cornerRadius: config.cornerRadius),
            lineWidth: config.borderWidth
        )
    }
}

// MARK: - SubViews
private extension GoalCardView {
    var myContent: some View {
        contentCell(
            item: config.myItem,
            placeholder: config.myPlaceholder,
            bottomLeadingRadius: config.cornerRadius
        )
        .onTapGesture(perform: actionLeft)
    }
    
    var yourContent: some View {
        contentCell(
            item: config.yourItem,
            placeholder: config.yourPlaceholder,
            bottomTrailingRadius: config.cornerRadius
        )
        .onTapGesture(perform: actionRight)
    }
    
    @ViewBuilder
    func contentCell(
        item: GoalCardItem.Card,
        placeholder: Configuration.Placeholder,
        bottomLeadingRadius: CGFloat = 0,
        bottomTrailingRadius: CGFloat = 0
    ) -> some View {
        let unEvenRoundedRect = UnevenRoundedRectangle(
            cornerRadii: .init(
                bottomLeading: bottomLeadingRadius,
                bottomTrailing: bottomTrailingRadius
            ),
            style: .continuous
        )
        
        Group {
            if let image = item.image {
                image
                    .resizable()
                    .clipShape(unEvenRoundedRect)
            } else {
                unCompletedView(placeholder: placeholder)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: config.imageHeight)
        .insideBorder(
            config.borderColor,
            shape: unEvenRoundedRect,
            lineWidth: config.borderWidth
        )
        .overlay(alignment: .bottomTrailing) {
            if let emoji = item.emoji {
                emojiImage(emoji: emoji)
            }
        }
    }
    
    func unCompletedView(placeholder: Configuration.Placeholder) -> some View {
        VStack(spacing: 0) {
            placeholder.image
            
            Text(placeholder.text)
                .typography(.b2_14r)
        }
    }
    
    func emojiImage(emoji: Image) -> some View {
        emoji
            .resizable()
            .frame(width: config.emojiSize.width, height: config.emojiSize.height)
            .padding([.bottom, .trailing], config.emojiPadding)
    }
}

// swiftlint: disable closure_body_length
#Preview {
    let items: [GoalCardItem] = [
        GoalCardItem(
            id: "1",
            goalName: "목표 이름",
            goalEmoji: .Icon.Illustration.exercise,
            myCard: .init(
                image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
                isSelected: true,
                emoji: nil
            ),
            yourCard: .init(
                image: SharedDesignSystemAsset.ImageAssets.girl.swiftUIImage,
                isSelected: true,
                emoji: nil
            )
        ),
        GoalCardItem(
            id: "2",
            goalName: "목표 이름",
            goalEmoji: .Icon.Illustration.exercise,
            myCard: .init(
                image: nil,
                isSelected: false,
                emoji: nil
            ),
            yourCard: .init(
                image: SharedDesignSystemAsset.ImageAssets.girl.swiftUIImage,
                isSelected: true,
                emoji: .Icon.Illustration.fuck
            )
        ),
        GoalCardItem(
            id: "3",
            goalName: "목표 이름",
            goalEmoji: .Icon.Illustration.exercise,
            myCard: .init(
                image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
                isSelected: true,
                emoji: .Icon.Illustration.heart
            ),
            yourCard: .init(
                image: nil,
                isSelected: false,
                emoji: nil
            )
        )
    ]
    
    VStack {
        ForEach(items.indices, id: \.self) { index in
            GoalCardView(
                config: .goalCheck(
                    item: items[index],
                    isMyChecked: items[index].myCard.isSelected,
                    isCoupleChecked: items[index].yourCard.isSelected,
                    action: { }
                ),
                actionLeft: { },
                actionRight: { }
            )
            .padding(.horizontal, Spacing.spacing8)
        }
    }
}
// swiftlint: enable closure_body_length
