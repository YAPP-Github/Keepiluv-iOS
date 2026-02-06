//
//  CameraPermissionAlert.swift
//  FeatureProofPhotoInterface
//
//  Created by 정지훈 on 2/6/26.
//

import SwiftUI
import UIKit

public extension View {
    func cameraPermissionAlert(
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> some View {
        alert(
            "현재 카메라 사용에 대한 접근 권한이 없습니다.",
            isPresented: isPresented
        ) {
            Button("설정") {
                onDismiss()
                openAppSettings()
            }
            Button("취소", role: .cancel) {
                onDismiss()
            }
        } message: {
            Text("설정 > KeepiLuv 탭에서 접근을 활성화 할 수 있습니다.")
        }
    }
}

private extension View {
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
