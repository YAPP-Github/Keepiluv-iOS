# NavigationStack 가이드

> 탭 내부에서 Push/Pop 화면 전환 구현하기

## 통일된 Navigation 패턴

프로젝트 전체에서 **`[Route]` 배열 패턴**을 사용합니다.

**TCA 공식 패턴(`StackState<Path.State>` + `@Reducer enum Path`)을 사용하지 않는 이유:**
- `@Reducer enum Path` 매크로가 Interface/Implementation 분리 구조에서 동작하지 않음
- 매크로가 `Path.detail(DetailReducer)`에서 `DetailReducer()`를 호출하려 하지만, Interface에서는 파라미터 없는 생성자에 접근 불가
- 코드 일관성을 위해 예외 Feature(Auth, Onboarding, MainTab)도 동일한 패턴 사용

---

## Route enum 정의

```swift
// OnboardingRoute.swift
public enum OnboardingRoute: Hashable {
    case codeInput
    case profile
    case dday
}
```

---

## Coordinator Reducer

### State

```swift
@ObservableState
public struct State: Equatable {
    var routes: [OnboardingRoute] = []  // Navigation path
    var connect: OnboardingConnectReducer.State  // Root 화면
    var codeInput: OnboardingCodeInputReducer.State?  // Optional child states
    var profile: OnboardingProfileReducer.State?
    var dday: OnboardingDdayReducer.State?
}
```

### Action

```swift
public enum Action: BindableAction {
    // MARK: - Binding
    case binding(BindingAction<State>)

    // MARK: - Child Action
    case connect(OnboardingConnectReducer.Action)
    case codeInput(OnboardingCodeInputReducer.Action)
    case profile(OnboardingProfileReducer.Action)
    case dday(OnboardingDdayReducer.Action)

    // MARK: - Delegate
    case delegate(Delegate)

    public enum Delegate: Equatable {
        case navigateBack
        case onboardingCompleted
    }
}
```

### Body

```swift
public var body: some ReducerOf<Self> {
    BindingReducer()

    Scope(state: \.connect, action: \.connect) {
        OnboardingConnectReducer()
    }

    Reduce { state, action in
        switch action {
        case .connect(.delegate(.navigateToCodeInput)):
            state.codeInput = OnboardingCodeInputReducer.State()
            state.routes.append(.codeInput)
            return .none

        case .codeInput(.delegate(.navigateBack)):
            state.routes.removeLast()
            state.codeInput = nil
            return .none

        case .codeInput(.delegate(.coupleConnected)):
            state.profile = OnboardingProfileReducer.State()
            state.routes.append(.profile)
            return .none
        // ...
        }
    }
    .ifLet(\.codeInput, action: \.codeInput) {
        OnboardingCodeInputReducer()
    }
    .ifLet(\.profile, action: \.profile) {
        OnboardingProfileReducer()
    }
    .ifLet(\.dday, action: \.dday) {
        OnboardingDdayReducer()
    }
}
```

---

## Coordinator View

```swift
public struct OnboardingCoordinatorView: View {
    @Bindable var store: StoreOf<OnboardingCoordinator>

    public var body: some View {
        NavigationStack(path: $store.routes) {
            OnboardingConnectView(
                store: store.scope(state: \.connect, action: \.connect)
            )
            .navigationDestination(for: OnboardingRoute.self) { route in
                switch route {
                case .codeInput:
                    if let codeInputStore = store.scope(
                        state: \.codeInput,
                        action: \.codeInput
                    ) {
                        OnboardingCodeInputView(store: codeInputStore)
                            .navigationBarBackButtonHidden(true)
                    }

                case .profile:
                    if let profileStore = store.scope(
                        state: \.profile,
                        action: \.profile
                    ) {
                        OnboardingProfileView(store: profileStore)
                            .navigationBarBackButtonHidden(true)
                    }

                case .dday:
                    if let ddayStore = store.scope(
                        state: \.dday,
                        action: \.dday
                    ) {
                        OnboardingDdayView(store: ddayStore)
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
    }
}
```

---

## Push/Pop 패턴

```swift
// Push: State 생성 후 route 추가
state.codeInput = OnboardingCodeInputReducer.State()
state.routes.append(.codeInput)

// Pop: route 제거 후 State 정리
state.routes.removeLast()
state.codeInput = nil

// Pop to Root
state.routes.removeAll()
```

---

## 핵심 포인트

1. **Route는 Hashable enum**: associated value 없이 순수 네비게이션 목적지만 정의
2. **Child State는 Optional**: 화면이 활성화될 때만 State 생성
3. **ifLet으로 Child Reducer 연결**: Optional State에 맞춰 조건부 Reducer 실행
4. **BindingReducer 필수**: `$store.routes` 바인딩을 위해 필요

---

## 전체 예제

`Projects/Feature/Onboarding/Sources/` 폴더의 다음 파일 참고:
- `OnboardingRoute.swift`
- `OnboardingCoordinator.swift`
- `OnboardingCoordinatorView.swift`

---

**작성일**: 2026-01-12
**수정일**: 2026-01-30 (통일된 Navigation 패턴으로 변경)
