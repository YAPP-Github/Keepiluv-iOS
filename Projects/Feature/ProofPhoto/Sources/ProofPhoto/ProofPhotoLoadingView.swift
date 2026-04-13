//
//  ProofPhotoLoadingView.swift
//  FeatureProofPhoto
//
//  Created by 정지훈 on 4/13/26.
//

import SwiftUI

import SharedDesignSystem

struct ProofPhotoLoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: Constants.stackSpacing) {
            Image.Illustration.plane
                .resizable()
                .frame(
                    width: Constants.imageWidth,
                    height: Constants.imageHeight
                )
                .rotationEffect(
                    .degrees(isAnimating ? Constants.rotationDegrees : .zero)
                )
                .animation(
                    .easeInOut(duration: Constants.animationDuration)
                    .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            Text(Constants.title)
                .typography(.h1_28b)
                .foregroundStyle(Color.Gray.gray500)
            
            Text(Constants.subTitle)
                .typography(.t2_16b)
                .foregroundStyle(Color.Gray.gray300)
                .padding(.top, Constants.descriptionTopPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Common.white)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    ProofPhotoLoadingView()
}

private extension ProofPhotoLoadingView {
    enum Constants {
        static let title: String = "인증샷 업로드 중..."
        static let subTitle: String = "잠시만 기다려 주세요."
        static let stackSpacing: CGFloat = 6
        static let imageWidth: CGFloat = 164
        static let imageHeight: CGFloat = 134
        static let rotationDegrees: Double = 10
        static let animationDuration: Double = 0.8
        static let descriptionTopPadding: CGFloat = 10
    }
}
