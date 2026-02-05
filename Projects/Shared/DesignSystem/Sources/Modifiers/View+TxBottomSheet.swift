//
//  View+TxBottomSheet.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/3/26.
//

import SwiftUI

public extension View {
    /// 뷰 하단에 커스텀 콘텐츠를 표시하는 바텀시트를 적용합니다.
    ///
    /// `isPresented` 바인딩 값에 따라 시트를 표시/닫기하며, 배경 탭으로 dismiss할 수 있습니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var isBottomSheetPresented = false
    ///
    /// SomeView()
    ///     .txBottomSheet(isPresented: $isBottomSheetPresented) {
    ///         VStack {
    ///             Text("Bottom Sheet")
    ///         }
    ///     }
    /// ```
    func txBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder
        sheetContent: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            TXBottomSheetModifier(
                isPresented: isPresented,
                sheetContent: sheetContent
            )
        )
    }
}

private struct TXBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var sheetContent: () -> SheetContent

    @State private var isCoverPresented = false
    @State private var sheetHeight: CGFloat = 0
    @State private var sheetOffset: CGFloat = UIScreen.main.bounds.height
    @State private var didCaptureInitialHeight = false
    @State private var dimmedOpacity: CGFloat = 0
    private let animationDuration: TimeInterval = 0.3

    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) {
                if isPresented {
                    isCoverPresented = true
                } else {
                    startDismiss()
                }
            }
            .fullScreenCover(
                isPresented: $isCoverPresented,
                onDismiss: {
                    resetSheetState()
                }
            ) {
                ZStack(alignment: .bottom) {
                    content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(.container, edges: .bottom)
                .onAppear { presentAnimated() }
                .presentationBackground { dimmedBackground }
            }
            .transaction { $0.disablesAnimations = true }
    }
}

// MARK: - SubViews {
private extension TXBottomSheetModifier {
    var content: some View {
        sheetContent()
            .readSize { frame in
                guard !didCaptureInitialHeight else { return }
                didCaptureInitialHeight = true
                sheetHeight = frame.height
                if dimmedOpacity == 0 {
                    sheetOffset = frame.height
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .background(Color.Common.white)
            .clipShape(
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: Radius.m, topTrailing: Radius.m))
            )
            .offset(y: sheetOffset)
    }
    
    var dimmedBackground: some View {
        Color.Dimmed.dimmed70
            .opacity(dimmedOpacity)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture { startDismiss() }
    }
}

// MARK: - Function
private extension TXBottomSheetModifier {
    func resetSheetState() {
        sheetHeight = 0
        sheetOffset = UIScreen.main.bounds.height
        didCaptureInitialHeight = false
        dimmedOpacity = 0
        isPresented = false
    }

    func presentAnimated() {
        withAnimation(.easeOut(duration: animationDuration)) {
            dimmedOpacity = 1
            sheetOffset = 0
        }
    }
    
    func startDismiss() {
        if isPresented {
            isPresented = false
        }

        withAnimation(.easeInOut(duration: animationDuration)) {
            sheetOffset = sheetHeight == 0 ? UIScreen.main.bounds.height : sheetHeight
            dimmedOpacity = 0
        }
        
        Task { @MainActor in
            try await Task.sleep(for: .seconds(animationDuration))
            isCoverPresented = false
        }
    }
}
