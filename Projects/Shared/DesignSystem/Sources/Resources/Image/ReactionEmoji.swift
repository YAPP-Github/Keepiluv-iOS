//
//  ReactionEmoji.swift
//  SharedDesignSystem
//
//  Created by Jihun on 2/11/26.
//

import SwiftUI

/// 목표 인증 리액션에 사용하는 공통 이모지 타입입니다.
///
/// ## 사용 예시
/// ```swift
/// let emoji: ReactionEmoji = .happy
/// let image = emoji.image
/// ```
public enum ReactionEmoji: String, CaseIterable, Equatable {
    case happy = "ICON_HAPPY"
    case trouble = "ICON_TROUBLE"
    case love = "ICON_LOVE"
    case doubt = "ICON_DOUBT"
    case fuck = "ICON_FUCK"
    
    public init?(from value: String) {
        self.init(rawValue: value)
    }
}

public extension ReactionEmoji {
    var image: Image {
        switch self {
        case .happy: Image.Icon.Illustration.happy
        case .trouble: Image.Icon.Illustration.trouble
        case .love: Image.Icon.Illustration.love
        case .doubt: Image.Icon.Illustration.doubt
        case .fuck: Image.Icon.Illustration.fuck
        }
    }
}
