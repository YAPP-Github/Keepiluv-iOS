//
//  TXModalView+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXModalView.Configuration {
    static func deleteGoal(
        image: Image = .Icon.Illustration.emoji2,
        title: String = "정말 인증을 취소하시겠어요?",
        subTitle: String = "사진도 지워져요",
        imageSize: CGSize = CGSize(width: 42, height: 42),
        imageFrameSize: CGSize = CGSize(width: 64, height: 64),
        onConfirm: @escaping () -> Void
    ) -> Self {
        .init(
            image: image,
            title: title,
            subTitle: subTitle,
            imageSize: imageSize,
            imageFrameSize: imageFrameSize,
            onConfirm: onConfirm
        )
    }
}
