//
//  TXToastType.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/28/26.
//

import SwiftUI

public enum TXToastType: Equatable {
    case success(message: String)
    case delete(message: String)
    case poke(message: String)
    case warning(message: String)
}

public extension TXToastType {
    var message: String {
        switch self {
        case let .success(message),
             let .delete(message),
             let .poke(message),
             let .warning(message):
            return message
        }
    }

    var icon: Image {
        switch self {
        case .success:
            return Image.Icon.Illustration.success
        case .delete:
            return Image.Icon.Illustration.delete
        case .poke:
            return Image.Icon.Illustration.heart
        case .warning:
            return Image.Icon.Illustration.delete
        }
    }

    var showButton: Bool {
        switch self {
        case .success:
            return true
        case .delete, .poke, .warning:
            return false
        }
    }

    var position: TXToastPosition { .bottom }
    var duration: TimeInterval? { 3.0 }
}
