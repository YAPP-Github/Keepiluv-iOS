//
//  TXToggleButton+Content.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import Foundation

extension TXToggleButton.Style {
    /// 토글 버튼 그룹에서 사용하는 콘텐츠를 정의합니다.
    public enum Content {
        case goalCheck
    }

    /// 토글 버튼 그룹의 개별 버튼 항목입니다.
    public enum Item {
        case myCheck
        case coupleCheck
    }
}

extension TXToggleButton.Style.Content {
    var items: [TXToggleButton.Style.Item] {
        switch self {
        case .goalCheck:
            return [.myCheck, .coupleCheck]
        }
    }
}
