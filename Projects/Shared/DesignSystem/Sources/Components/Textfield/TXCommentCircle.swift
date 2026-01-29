//
//  TXCommentCircle.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/22/26.
//

import SwiftUI

/// 코멘트 입력을 위한 원형 텍스트 필드 컴포넌트입니다.
public struct TXCommentCircle: View {
    @Binding private var commentText: String
    @FocusState private var isFocused: Bool
    private let isEditable: Bool
    public var onFocused: ((Bool) -> Void)?
    
    /// 코멘트 텍스트 바인딩과 편집 가능 여부를 전달해 컴포넌트를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXCommentCircle(
    ///     commentText: $commentText,
    ///     isEditable: true
    /// )
    /// ```
    public init(
        commentText: Binding<String>,
        isEditable: Bool,
        onFocused: ((Bool) -> Void)? = nil
    ) {
        self._commentText = commentText
        self.isEditable = isEditable
        self.onFocused = onFocused
    }
    
    public var body: some View {
        ZStack {
            borderCircles
            fillCircles
            textCircles
        }
        .safeAreaInset(edge: .bottom) {
            if isFocused {
                Color.clear
                    .frame(height: Constants.keyboardPadding)
            }
        }
        .onChange(of: isFocused) {
            onFocused?(isFocused)
        }
    }
}

// MARK: - SubViews
private extension TXCommentCircle {
    var borderCircles: some View {
        HStack(spacing: Constants.circleSpacing) {
            ForEach(0..<Constants.maxCount, id: \.self) { _ in
                Circle()
                    .outsideBorder(.black, shape: .circle, lineWidth: 2)
                    .frame(width: Constants.circleSize, height: Constants.circleSize)
            }
        }
    }
    
    var fillCircles: some View {
        HStack(spacing: Constants.circleSpacing) {
            ForEach(0..<Constants.maxCount, id: \.self) { _ in
                Circle()
                    .fill(Color.white)
                    .frame(width: Constants.circleSize, height: Constants.circleSize)
            }
        }
    }
    
    var textCircles: some View {
        HStack(spacing: Constants.circleSpacing) {
            ForEach(0..<Constants.maxCount, id: \.self) { index in
                Text(circleText(at: index))
                    .typography(.h1_28b)
                    .foregroundColor(
                        commentText.isEmpty ? Color.Gray.gray200 : Color.Gray.gray500
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
    
    func circleText(at index: Int) -> String {
        let textArray = Array(commentText)
        if textArray.isEmpty {
            return String(Constants.placeholder[index])
        }

        return index < textArray.count ? String(textArray[index]) : ""
    }
}

private enum Constants {
    static let maxCount = 5
    static let circleSize: CGFloat = 62
    static let circleSpacing: CGFloat = -14
    static let placeholder = Array("코멘트추가")
    static let keyboardPadding: CGFloat = 80
}

#Preview {
    @Previewable @State var text: String = ""
    TXCommentCircle(
        commentText: $text,
        isEditable: true
    )
}
