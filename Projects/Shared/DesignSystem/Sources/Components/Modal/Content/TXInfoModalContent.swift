//
//  TXInfoModalContent.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/4/26.
//

import SwiftUI

/// 이미지, 제목, 설명으로 구성된 정보형 모달 콘텐츠입니다.
struct TXInfoModalContent: View {
    private let image: Image
    private let title: String
    private let subtitle: String
    
    init(
        image: Image,
        title: String,
        subtitle: String
    ) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(spacing: Constants.vStackSpacing) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
                .padding(.top, Constants.imageTopPadding)

            Text(title)
                .typography(Constants.titleTypography)
                .multilineTextAlignment(.center)
                .padding(.top, Constants.titleTopPadding)

            Text(subtitle)
                .typography(Constants.subtitleTypography)
                .multilineTextAlignment(.center)
                .padding(.top, Constants.subtitleTopPadding)
        }
    }
}

// MARK: - Constants
private extension TXInfoModalContent {
    enum Constants {
        static let vStackSpacing: CGFloat = 0
        static let imageSize = CGSize(width: 60, height: 60)
        static let imageTopPadding = Spacing.spacing8
        static let titleTopPadding = Spacing.spacing7
        static let subtitleTopPadding = Spacing.spacing5
        static let titleTypography = TypographyToken.t1_18eb
        static let subtitleTypography = TypographyToken.b2_14r
    }
}
