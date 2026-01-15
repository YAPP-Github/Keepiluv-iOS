# NavigationStack 가이드

> 탭 내부에서 Push/Pop 화면 전환 구현하기

NavigationStack 패턴에 대한 자세한 내용은 프로젝트 루트의 `NavigationStackExample.swift` 파일을 참고하세요.

## 핵심 개념

### StackState 사용

```swift
@ObservableState
struct State {
    var path = StackState<Path.State>()  // 화면 스택
    
    enum Path: Equatable {
        case detail(DetailReducer.State)
        case settings(SettingsReducer.State)
    }
}
```

### Push/Pop 조작

```swift
// Push
state.path.append(.detail(DetailReducer.State()))

// Pop
state.path.removeLast()

// Pop to Root
state.path.removeAll()
```

## 자세한 예제

전체 구현 예제는 `../Examples/NavigationStackExample.swift` 파일을 참고하세요.

---

**작성일**: 2026-01-12
