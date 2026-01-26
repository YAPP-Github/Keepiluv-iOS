//
//  Goal.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/26/26.
//

import SwiftUI

public struct Goal {
    // TODO: - Image로 임시 대체 후 Data로 타입 변경
    let id: String
    let goalIcon: Image
    let title: String
    let isCompleted: Bool
    var image: Image?
    var emoji: Image?
}
