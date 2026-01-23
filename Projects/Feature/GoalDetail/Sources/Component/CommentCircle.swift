//
//  CommentCircle.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/22/26.
//

import SwiftUI

import SharedDesignSystem

struct CommentCircle: View {
    
    let commentText: String
    
    var body: some View {
        let maxCount = 5
        let placeholder = Array("코멘트추가")
        let characters = Array(commentText)
        
        ZStack {
            // border circles
            HStack(spacing: -14) {
                ForEach(0..<maxCount, id: \.self) { _ in
                    Circle()
                        .outsideBorder(.black, shape: .circle, lineWidth: 2)
                        .frame(width: 62, height: 62)
                }
            }
            
            // fill circles
            HStack(spacing: -14) {
                ForEach(0..<maxCount, id: \.self) { _ in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 62, height: 62)
                }
            }
            
            // text / placeholder
            HStack(spacing: -14) {
                ForEach(0..<maxCount, id: \.self) { index in
                    Text(
                        characters.isEmpty
                        ? String(placeholder[index])
                        : (index < characters.count ? String(characters[index]) : "")
                    )
                    .typography(.h1_28b)
                    .foregroundColor(
                        characters.isEmpty ? Color.Gray.gray200 : Color.Gray.gray500
                    )
                    .frame(width: 62, height: 62)
                }
            }
        }
    }
}
