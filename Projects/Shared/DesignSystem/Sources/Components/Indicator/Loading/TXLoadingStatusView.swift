//
//  TXLoadingStatusView.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 5/5/26.
//

import SwiftUI

struct TXLoadingStatusView: View {
    let message: String

    init(message: String = "로딩 중...") {
        self.message = message
    }

    var body: some View {
        HStack(spacing: 12) {
            TXLoadingIndicator()
            
            Text(message)
                .typography(.b1_14b)
                .foregroundStyle(Color.Gray.gray500)
        }
        .frame(width: 159, height: 60)
        .background(
            Capsule()
                .fill(Color.Common.white)
        )
    }
}

#Preview {
    TXLoadingStatusView()
}
