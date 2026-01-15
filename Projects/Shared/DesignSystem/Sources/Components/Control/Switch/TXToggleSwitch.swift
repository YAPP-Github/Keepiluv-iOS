//
//  TXToggleSwitch.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// 디자인 시스템에서 사용하는 토글 스위치 컴포넌트입니다.
public struct TXToggleSwitch: View {
    @Binding var isOn: Bool
    
    /// 바인딩된 상태값으로 토글 스위치를 초기화합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXToggleSwitch(isOn: $store.sending(\.isOn)
    /// ```
    public init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }
    
    public var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(TXToggleSwitchStyle())
    }
}

private struct TXToggleSwitchStyle: ToggleStyle {
    let frameWidth: CGFloat = 48
    let frameHeight: CGFloat = 30
    let frameRadius: CGFloat = 32
    let borderWidth: CGFloat = 32
    
    let circleSize: CGFloat = 22
    var circleRadius: CGFloat {
        return frameWidth / 2
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: configuration.isOn ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: frameRadius)
                .fill(configuration.isOn ? Color.Gray.gray500 : Color.Common.white)
                .stroke(Color.Gray.gray500, lineWidth: LineWidth.l)
                .frame(width: frameWidth, height: frameHeight)
                .foregroundStyle(configuration.isOn ? Color.Gray.gray500 : Color.Common.white)
                
            RoundedRectangle(cornerRadius: circleRadius)
                .frame(width: circleSize, height: circleSize)
                .padding(Spacing.spacing4)
                .foregroundStyle(configuration.isOn ? Color.Common.white : Color.Gray.gray500)
                .onTapGesture {
                    withAnimation {
                        configuration.$isOn.wrappedValue.toggle()
                    }
                }
        }
    }
}

#Preview {
    @Previewable @State var isOn = false
    
    TXToggleSwitch(isOn: $isOn)
}
