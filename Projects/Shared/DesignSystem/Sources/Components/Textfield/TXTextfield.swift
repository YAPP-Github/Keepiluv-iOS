//
//  TXTextField.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/16/26.
//

import SwiftUI

/// 하단 라인이 있는 기본 텍스트 입력 필드 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// @State var text: String = ""
/// TXTextField(text: $text, placeholderText: "플레이스홀더")
/// ```
public struct TXTextField: View {
    
    @Binding public var text: String
    private let placeholderText: String
    
    /// 텍스트 바인딩과 플레이스홀더를 전달해 텍스트 필드를 생성합니다.
    public init(
        text: Binding<String>,
        placeholderText: String
    ) {
        self._text = text
        self.placeholderText = placeholderText
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                textField
                
                Spacer()
                
                if !text.isEmpty {
                    clearButton
                }
            }
            underLine
        }
    }
}

// MARK: - SubViews
private extension TXTextField {
    var textField: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeHolderView
            }

            TextField("", text: $text)
        }
        .padding(.leading, Spacing.spacing5)
    }
    
    var placeHolderView: some View {
        Text(placeholderText)
            .typography(.t2_16b)
            .foregroundStyle(.secondary)
    }
    
    var clearButton: some View {
        TXCircleButton(
            config: .clear(colorStyle: .gray200)
        ) {
            text = ""
        }
        .frame(width: 24, height: 24)
        .padding(.horizontal, 10)
    }
    
    var underLine: some View {
        Rectangle()
            .foregroundStyle(Color.Gray.gray500)
            .frame(width: .infinity, height: 1)
            .padding(.top, Spacing.spacing5)
    }
}

#Preview {
    @Previewable @State var text: String = ""
    TXTextField(text: $text, placeholderText: "플레이스홀더")
        .padding(.horizontal, 20)
}
