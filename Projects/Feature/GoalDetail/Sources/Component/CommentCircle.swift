//
//  CommentCircle.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/22/26.
//

import SwiftUI

import SharedDesignSystem

struct CommentCircle: View {
    @Binding var commentText: String
    @FocusState private var isFocused: Bool
    private var isEditable: Bool
    
    init(
        commentText: Binding<String>,
        isEditable: Bool
    ) {
        self._commentText = commentText
        self.isEditable = isEditable
    }
    
    
    var body: some View {
        ZStack {
            // border circles
            HStack(spacing: Constants.circleSpacing) {
                ForEach(0..<Constants.maxCount, id: \.self) { _ in
                    Circle()
                        .outsideBorder(.black, shape: .circle, lineWidth: 2)
                        .frame(width: Constants.circleSize, height: Constants.circleSize)
                }
            }
            
            // fill circles
            HStack(spacing: Constants.circleSpacing) {
                ForEach(0..<Constants.maxCount, id: \.self) { _ in
                    Circle()
                        .fill(Color.white)
                        .frame(width: Constants.circleSize, height: Constants.circleSize)
                }
            }
            
            // text / placeholder
            HStack(spacing: Constants.circleSpacing) {
                ForEach(0..<Constants.maxCount, id: \.self) { index in
                    Text(
                        Array(commentText).isEmpty
                        ? String(Constants.placeholder[index])
                        : (index < Array(commentText).count ? String(Array(commentText)[index]) : "")
                    )
                    .typography(.h1_28b)
                    .foregroundColor(
                        Array(commentText).isEmpty ? Color.Gray.gray200 : Color.Gray.gray500
                    )
                    .frame(width: Constants.circleSize, height: Constants.circleSize)
                }
            }
            .onTapGesture {
                isFocused = isEditable
            }
            .background {
                TextField("", text: $commentText)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .opacity(0)
            }
        }
    }
}

private enum Constants {
    static let maxCount = 5
    static let circleSize: CGFloat = 62
    static let circleSpacing: CGFloat = -14
    static let placeholder = Array("코멘트추가")
}
