//
//  TXModalView+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXModalView.Configuration {
    static func deleteGoal(
        image: Image,
        imageSize: CGSize = CGSize(width: 42, height: 42),
        imageFrameSize: CGSize = CGSize(width: 64, height: 64),
        title: String,
        subTitle: String = "목표를 완료해도 저장된 사진은 사라지지 않아요",
        onConfirm: @escaping () -> Void
    ) -> Self {
        .init(
            image: image,
            imageSize: imageSize,
            imageFrameSize: imageFrameSize,
            title: title,
            subTitle: subTitle,
            onConfirm: onConfirm
        )
    }
}
