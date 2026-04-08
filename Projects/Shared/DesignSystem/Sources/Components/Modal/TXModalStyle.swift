//
//  TXModalType.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/27/26.
//

import SwiftUI

/// 모달 UI에서 사용할 수 있는 유형을 정의합니다.
///
/// `TXModalStyle`은 DesignSystem 레벨의 표현 구조만 정의합니다.
/// 호출부에서 필요한 이미지와 문구를 직접 주입합니다.
///
/// ## 사용 예시
/// ```swift
/// state.modal = .info(
///     image: .Icon.Illustration.modalWarning,
///     title: "체크를 해제할까요?",
///     subtitle: "해제하면 등록한 사진은 사라집니다.",
///     leftButtonText: "취소",
///     rightButtonText: "해제"
/// )
/// ```

public enum TXModalStyle: Equatable {
    case info(
        image: Image,
        title: String,
        subtitle: String,
        leftButtonText: String,
        rightButtonText: String
    )
    case selection(
        title: String,
        icons: [Image],
        selectedIndex: Int,
        buttonTitle: String
    )
    case selectList(
        title: String,
        subtitle: String?,
        options: [String],
        selectedIndex: Int,
        leftButtonText: String,
        rightButtonText: String
    )
}

extension TXModalStyle: Identifiable {
    public var id: String {
        switch self {
        case .info:
            return "info"
            
        case .selection:
            return "selection"

        case .selectList:
            return "selectList"
        }
    }
}
