//
//  TXToggleButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

struct TXToggleCircle: View {
    @Binding var isSelected: Bool
    
    let type: TXToggleButtonType

    var body: some View {
        
        Circle()
            .fill(type.fillColor(isSelected: isSelected))
            .strokeBorder(type.strokeBorderColor(isSelected: isSelected), lineWidth: type.strokeBorderWidth(isSelected: isSelected))
            .stroke(type.strokeColor, lineWidth: type.strokeWidth)
            .frame(width: type.circleFrameSize, height: type.circleFrameSize)
            .overlay(
                type.selectedImage
                    .resizable()
                    .frame(width: type.selectedImageWidth, height: type.selectedImageHeight)
                    .foregroundStyle(type.selectedImageColor)
                    .opacity(isSelected ? 1 : 0)
            )
            .frame(width: type.buttonFrameSize, height: type.buttonFrameSize)
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

#Preview {
    @Previewable @State var myisSelected = false
    @Previewable @State var coupleisSelected = false
    VStack {
        HStack {
            TXToggleCircle(isSelected: $myisSelected, type: .myCheck)
            TXToggleCircle(isSelected: $coupleisSelected, type: .coupleCheck)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.cyan)
}
