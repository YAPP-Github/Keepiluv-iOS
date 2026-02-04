//
//  KLIcons.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/13/26.
//

import SwiftUI

public extension Image {
    /// 모듈 공통 아이콘 네임스페이스입니다.
    enum Icon { }
    /// 모듈 공통 일러스트 네임스페이스입니다.
    enum Illustration { }
    /// 모듈 공통 벡터 리소스 네임스페이스입니다.
    enum Vector { }
}

/// 모듈 전반에서 공통으로 사용하는 Icon형식의 Image 입니다.
public extension Image.Icon {
    /// 아이콘 일러스트 네임스페이스입니다.
    enum Illustration { }
    /// 아이콘 심볼 네임스페이스입니다.
    enum Symbol { }
}

/// 모듈 전반에서 공통으로 사용하는 Illustration형식의 Icon 입니다.
public extension Image.Icon.Illustration {
    typealias IllustrationAsset = SharedDesignSystemAsset.ImageAssets.Icons.Illustration
    
    static let add = IllustrationAsset.iconAdd.swiftUIImage
    static let delete = IllustrationAsset.iconDelete.swiftUIImage
    static let emoji1 = IllustrationAsset.iconEmoji1.swiftUIImage
    static let emoji2 = IllustrationAsset.iconEmoji2.swiftUIImage
    static let emoji3 = IllustrationAsset.iconEmoji3.swiftUIImage
    static let emoji4 = IllustrationAsset.iconEmoji4.swiftUIImage
    static let emoji5 = IllustrationAsset.iconEmoji5.swiftUIImage
    static let emojiAdd = IllustrationAsset.iconEmojiAdd.swiftUIImage
    static let exercise = IllustrationAsset.iconExercise.swiftUIImage
    static let heart = IllustrationAsset.iconHeart.swiftUIImage
    static let success = IllustrationAsset.iconSuccess.swiftUIImage
    static let goalEmpty = IllustrationAsset.iconGoalEmpty.swiftUIImage
    static let warning = IllustrationAsset.iconWarning.swiftUIImage
    static let `default` = IllustrationAsset.iconDefault.swiftUIImage
    static let clean = IllustrationAsset.iconClean.swiftUIImage
    static let book = IllustrationAsset.iconBook.swiftUIImage
    static let pencil = IllustrationAsset.iconPencil.swiftUIImage
    static let health = IllustrationAsset.iconHealth.swiftUIImage
    static let heartDouble = IllustrationAsset.iconHeartDouble.swiftUIImage
    static let laptop = IllustrationAsset.iconLaptop.swiftUIImage
}

/// 모듈 전반에서 공통으로 사용하는 Symbol형식의 Icon 입니다.
public extension Image.Icon.Symbol {
    typealias SymbolAsset = SharedDesignSystemAsset.ImageAssets.Icons.Symbol
    
    static let alert = SymbolAsset.icAlert.swiftUIImage
    static let alertRemained = SymbolAsset.icAlertRemained.swiftUIImage
    static let arrow1MLeft = SymbolAsset.icArrow1MLeft.swiftUIImage
    static let arrow1MRight = SymbolAsset.icArrow1MRight.swiftUIImage
    static let arrow1SRight = SymbolAsset.icArrow1SRight.swiftUIImage
    static let arrow3Left = SymbolAsset.icArrow3Left.swiftUIImage
    static let arrow3Right = SymbolAsset.icArrow3Right.swiftUIImage
    static let arrow4 = SymbolAsset.icArrow4.swiftUIImage
    static let unCheckMe = SymbolAsset.icUnCheckMe.swiftUIImage
    static let checkMe = SymbolAsset.icCheckMe.swiftUIImage
    static let unCheckYou = SymbolAsset.icUnCheckYou.swiftUIImage
    static let checkYou = SymbolAsset.icCheckYou.swiftUIImage
    static let closeM = SymbolAsset.icCloseM.swiftUIImage
    static let closeS = SymbolAsset.icCloseS.swiftUIImage
    static let edit = SymbolAsset.icEdit.swiftUIImage
    static let flash = SymbolAsset.icFlash.swiftUIImage
    static let flashDefault = SymbolAsset.icFlashDefault.swiftUIImage
    static let meatball = SymbolAsset.icMeatball.swiftUIImage
    static let minus = SymbolAsset.icMinus.swiftUIImage
    static let plus = SymbolAsset.icPlus.swiftUIImage
    static let icReturn = SymbolAsset.icReturn.swiftUIImage
    static let setting = SymbolAsset.icSetting.swiftUIImage
    static let turn = SymbolAsset.icTurn.swiftUIImage
    static let selectedNone1 = SymbolAsset.selectedNone1.swiftUIImage
    static let selectedNone2 = SymbolAsset.selectedNone2.swiftUIImage
    static let selectedNone = SymbolAsset.selectedNone.swiftUIImage
    static let selectedSelected1 = SymbolAsset.selectedSelected1.swiftUIImage
    static let selectedSelected2 = SymbolAsset.selectedSelected2.swiftUIImage
    static let selectedSelected = SymbolAsset.selectedSelected.swiftUIImage
    static let gallery = SymbolAsset.icGallery.swiftUIImage
    static let arrow2Down = SymbolAsset.icArrow2Down.swiftUIImage
}

public extension Image.Illustration {
    typealias IllustrationAsset = SharedDesignSystemAsset.ImageAssets.Illustration
    
    static let keepiluv = IllustrationAsset.illustKeepiluv.swiftUIImage
    static let poke = IllustrationAsset.illustPoke.swiftUIImage
}

public extension Image.Vector {
    typealias IllustrationAsset = SharedDesignSystemAsset.ImageAssets.Vector
    
    static let curveArrow = IllustrationAsset.curveArrow.swiftUIImage
}
