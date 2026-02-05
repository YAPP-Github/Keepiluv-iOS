//
//  TXInfoModalContent.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/4/26.
//

import SwiftUI

/// 아이콘/제목/설명으로 구성된 정보형 모달 콘텐츠입니다.
public struct TXInfoModalContent: View {
    /// 정보형 모달 콘텐츠의 표시 구성을 정의합니다.
    public struct Configuration: Equatable {
        let image: Image
        let title: String
        let subtitle: String
        let leftButtonText: String
        let rightButtonText: String
        let imageSize: CGSize
        
        /// 정보형 모달 콘텐츠 구성을 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let config = TXInfoModalContent.Configuration(
        ///     image: .Icon.Illustration.emoji2,
        ///     title: "목표를 이루셨나요?",
        ///     subtitle: "목표를 완료해도 사진은 사라지지 않아요",
        ///     leftButtonText: "취소",
        ///     rightButtonText: "삭제"
        /// )
        /// ```
        public init(
            image: Image,
            title: String,
            subtitle: String,
            leftButtonText: String,
            rightButtonText: String,
            imageSize: CGSize = CGSize(width: 60, height: 60)
        ) {
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.leftButtonText = leftButtonText
            self.rightButtonText = rightButtonText
            self.imageSize = imageSize
        }
    }
    
    private let config: Configuration
    
    /// 정보형 모달 콘텐츠를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXInfoModalContent(config: .deleteGoal)
    /// ```
    public init(config: Configuration) {
        self.config = config
    }

    public var body: some View {
        VStack(spacing: 0) {
            config.image
                .resizable()
                .scaledToFit()
                .frame(width: config.imageSize.width, height: config.imageSize.height)
                .padding(.top, Spacing.spacing8)

            Text(config.title)
                .typography(.t1_18eb)
                .multilineTextAlignment(.center)
                .padding(.top, Spacing.spacing7)

            Text(config.subtitle)
                .typography(.b2_14r)
                .padding(.top, Spacing.spacing6)
        }
    }
}

#Preview {
    TXInfoModalContent(
        config: .init(
            image: .Icon.Illustration.emoji2,
            title: "목표를 이루셨나요?",
            subtitle: "목표를 완료해도 사진은 사라지지 않아요",
            leftButtonText: "취소",
            rightButtonText: "삭제"
        )
    )
}
