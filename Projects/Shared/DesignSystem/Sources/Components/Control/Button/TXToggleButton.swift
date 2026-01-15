//
//  TXToggleButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// 디자인 시스템에서 사용하는 토글 버튼 컴포넌트입니다.
public struct TXToggleButton: View {
    @Binding var isSelected: Bool
    let buttonType: TXToggleButtonType

    /// 바인딩된 선택 상태와 버튼 타입으로 토글 버튼을 초기화합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXToggleButton(isSelected: $isSelected, buttonType: .coupleCheck)
    /// ```
    public init(isSelected: Binding<Bool>, buttonType: TXToggleButtonType) {
        self._isSelected = isSelected
        self.buttonType = buttonType
    }
    
    public var body: some View {
        Toggle("", isOn: $isSelected)
            .toggleStyle(TXToggleButtonStyle(type: buttonType))
    }
}

private struct TXToggleButtonStyle: ToggleStyle {
    let type: TXToggleButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        
        Circle()
            .fill(type.fillColor(isSelected: configuration.isOn))
            .strokeBorder(
                type.strokeBorderColor(isSelected: configuration.isOn),
                lineWidth: type.strokeBorderWidth(isSelected: configuration.isOn)
            )
            .stroke(type.strokeColor, lineWidth: type.strokeWidth)
            .frame(width: type.circleFrameSize, height: type.circleFrameSize)
            .overlay(
                type.selectedImage
                    .resizable()
                    .frame(width: type.selectedImageWidth, height: type.selectedImageHeight)
                    .foregroundStyle(type.selectedImageColor)
                    .opacity(configuration.isOn ? 1 : 0)
            )
            .frame(width: type.buttonFrameSize, height: type.buttonFrameSize)
            .onTapGesture {
                configuration.$isOn.wrappedValue.toggle()
            }
    }
}

#Preview {
    @Previewable @State var mySelected = false
    @Previewable @State var coupleSelected = false
    VStack {
        HStack {
            TXToggleButton(isSelected: $mySelected, buttonType: .myCheck)
            TXToggleButton(isSelected: $coupleSelected, buttonType: .coupleCheck)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.cyan)
}
