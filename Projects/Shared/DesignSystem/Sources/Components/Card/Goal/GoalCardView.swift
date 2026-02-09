//
//  GoalCardView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

import Kingfisher

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
            let isButton: Bool
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
                text: "KEEP IT UP!",
                isButton: false
            ),
            yourPlaceholder: Placeholder = .init(
                image: Image.Illustration.poke,
                text: "찌르기!",
                isButton: true
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
    
    @ViewBuilder
    var yourContent: some View {
        let hasImage = config.yourItem.imageURL != nil

        contentCell(
            item: config.yourItem,
            placeholder: config.yourPlaceholder,
            bottomTrailingRadius: config.cornerRadius,
            buttonAction: hasImage ? nil : actionRight
        )
        .onTapGesture {
            if hasImage {
                actionRight()
            }
        }
    }
    
    @ViewBuilder
    func contentCell(
        item: GoalCardItem.Card,
        placeholder: Configuration.Placeholder,
        bottomLeadingRadius: CGFloat = 0,
        bottomTrailingRadius: CGFloat = 0,
        buttonAction: (() -> Void)? = nil
    ) -> some View {
        let unEvenRoundedRect = UnevenRoundedRectangle(
            cornerRadii: .init(
                bottomLeading: bottomLeadingRadius,
                bottomTrailing: bottomTrailingRadius
            )
        )

        Group {
            if let imageURL = item.imageURL {
                KFImage(imageURL)
                    .resizable()
                    .placeholder { }
                    .scaledToFill()
            } else {
                unCompletedView(placeholder: placeholder, buttonAction: buttonAction)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: config.imageHeight)
        .clipShape(unEvenRoundedRect)
        .clipped()
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
    
    func unCompletedView(
        placeholder: Configuration.Placeholder,
        buttonAction: (() -> Void)? = nil
    ) -> some View {
        VStack(spacing: 0) {
            placeholder.image
                .resizable()
                .frame(width: 80, height: 80)
            
            if placeholder.isButton {
                pokeButton(text: placeholder.text, action: buttonAction)
            } else {
                Text(placeholder.text)
                    .typography(.b4_12b)
                    .foregroundStyle(Color.Gray.gray400)
            }
        }
    }

    func pokeButton(text: String, action: (() -> Void)?) -> some View {
        Button {
            action?()
        } label: {
            // TODO: - DesignSystem Component화 하기
            ZStack {
                // Shadow
                RoundedRectangle(cornerRadius: 999)
                    .fill(Color.Gray.gray500)
                    .frame(width: 64, height: 31)
                    .offset(y: 1)

                // Button
                Text(text)
                    .typography(.c2_11b)
                    .foregroundStyle(Color.Gray.gray500)
                    .frame(width: 64, height: 28)
                    .background(Color.Common.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.Gray.gray500, lineWidth: 1)
                    )
            }
            .frame(width: 64, height: 32)
        }
        .buttonStyle(.plain)
    }
    
    func emojiImage(emoji: Image) -> some View {
        emoji
            .resizable()
            .frame(width: config.emojiSize.width, height: config.emojiSize.height)
            .padding([.bottom, .trailing], config.emojiPadding)
    }
}
