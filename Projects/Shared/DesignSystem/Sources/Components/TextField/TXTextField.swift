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
    private var isFocused: FocusState<Bool>.Binding?
    private let submitLabel: SubmitLabel
    private let tintColor: Color
    private let subText: SubTextConfiguration?

    /// SubText 설정
    public struct SubTextConfiguration {
        let text: String
        let state: State

        public enum State {
            case valid
            case invalid
            case empty
        }

        public init(text: String, state: State) {
            self.text = text
            self.state = state
        }

        var color: Color {
            switch state {
            case .valid:
                return Color.Status.success
            case .invalid:
                return Color.Status.warning
            case .empty:
                return Color.Gray.gray300
            }
        }
    }

    /// 텍스트 바인딩과 플레이스홀더를 전달해 텍스트 필드를 생성합니다.
    public init(
        text: Binding<String>,
        placeholderText: String,
        isFocused: FocusState<Bool>.Binding? = nil,
        submitLabel: SubmitLabel = .return,
        tintColor: Color = Color.Gray.gray500,
        subText: SubTextConfiguration? = nil
    ) {
        self._text = text
        self.placeholderText = placeholderText
        self.isFocused = isFocused
        self.submitLabel = submitLabel
        self.tintColor = tintColor
        self.subText = subText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: subText != nil ? Spacing.spacing5 : 0) {
            container

            if let subText {
                subTextView(config: subText)
            }
        }
    }
}

// MARK: - SubViews
private extension TXTextField {
    var container: some View {
        HStack(spacing: 0) {
            textField

            Spacer()

            if !text.isEmpty {
                clearButton
            }
        }
        .frame(height: 52)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.Gray.gray500)
                .frame(height: 1)
        }
    }

    @ViewBuilder
    var textField: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeHolderView
            }

            if let isFocused {
                TextField("", text: $text)
                    .focused(isFocused)
                    .submitLabel(submitLabel)
                    .tint(tintColor)
            } else {
                TextField("", text: $text)
                    .submitLabel(submitLabel)
                    .tint(tintColor)
            }
        }
        .padding(.leading, Spacing.spacing5)
    }

    var placeHolderView: some View {
        Text(placeholderText)
            .typography(.t2_16b)
            .foregroundStyle(Color.Gray.gray200)
    }

    var clearButton: some View {
        TXCircleButton(
            config: .clear(colorStyle: .gray200)
        ) {
            text = ""
        }
        .frame(width: 24, height: 24)
        .frame(width: 44, height: 44)
    }

    func subTextView(config: SubTextConfiguration) -> some View {
        HStack(spacing: Spacing.spacing3) {
            checkCircleIcon(color: config.color)

            Text(config.text)
                .typography(.c2_11b)
                .foregroundStyle(config.color)
        }
    }

    func checkCircleIcon(color: Color) -> some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 14, height: 14)

            Path { path in
                path.move(to: CGPoint(x: 3.5, y: 7))
                path.addLine(to: CGPoint(x: 6, y: 9.5))
                path.addLine(to: CGPoint(x: 10.5, y: 4.5))
            }
            .stroke(Color.Common.white, style: StrokeStyle(lineWidth: 1.2, lineCap: .round, lineJoin: .round))
            .frame(width: 14, height: 14)
        }
        .frame(width: 16, height: 16)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Default
        TXTextField(
            text: .constant(""),
            placeholderText: "플레이스홀더"
        )

        // With text
        TXTextField(
            text: .constant("입력 중"),
            placeholderText: "플레이스홀더"
        )

        // With subText - valid
        TXTextField(
            text: .constant("닉네임"),
            placeholderText: "플레이스홀더",
            subText: .init(text: "닉네임 2-8자", state: .valid)
        )

        // With subText - invalid
        TXTextField(
            text: .constant("A"),
            placeholderText: "플레이스홀더",
            subText: .init(text: "닉네임 2-8자", state: .invalid)
        )
    }
    .padding(.horizontal, 20)
}
