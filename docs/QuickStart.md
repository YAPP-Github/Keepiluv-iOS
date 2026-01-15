# 빠른 시작 (Quick Start)

> 10분 만에 TCA 기본 개념을 이해하고 첫 Feature를 만들어봅시다

## 📋 목차

1. [TCA 핵심 개념 (5분)](#tca-핵심-개념)
2. [첫 Feature 만들기 (10분)](#첫-feature-만들기)
3. [다음 단계](#다음-단계)

---

## TCA 핵심 개념

### MVVM-C와 비교

| 개념 | MVVM-C | TCA |
|------|--------|-----|
| **상태 관리** | ViewModel의 `@Published` 프로퍼티 | `State` struct |
| **이벤트 처리** | ViewModel 메서드 호출 | `Action` enum |
| **비즈니스 로직** | ViewModel 내부 메서드 | `Reducer` |
| **비동기 작업** | Combine Publisher | `Effect` |
| **화면 전환** | `Coordinator` | `State` 변경 |

### 1. State - 화면의 모든 상태

```swift
@ObservableState
struct State: Equatable {
    var count = 0
    var isLoading = false
    var errorMessage: String?
}
```

**핵심**:
- 화면에 표시되는 모든 데이터
- `Equitable` 준수 필수
- `@ObservableState` 매크로로 SwiftUI 자동 구독

### 2. Action - 발생 가능한 모든 이벤트

```swift
enum Action {
    // 사용자 액션
    case incrementButtonTapped
    case decrementButtonTapped

    // 시스템 응답
    case dataResponse(Result<Data, Error>)

    // Lifecycle
    case onAppear
}
```

**네이밍 규칙**:
- 사용자 액션: `<동사><대상>Tapped/Changed`
- 시스템 응답: `<이름>Response`
- Lifecycle: `on<이벤트>`

### 3. Reducer - State + Action → 새로운 State + Effect

```swift
var body: some ReducerOf<Self> {
    Reduce { state, action in
        switch action {
        case .incrementButtonTapped:
            state.count += 1          // State 변경
            return .none              // Effect 반환

        case .decrementButtonTapped:
            state.count -= 1
            return .none
        }
    }
}
```

**규칙**:
1. State를 직접 변경
2. Effect를 반환 (`.none`, `.run`, `.send` 등)
3. 순수 함수 (Side Effect 금지)

### 4. Store - State 저장 + Action 처리

```swift
let store = Store(
    initialState: CounterReducer.State()
) {
    CounterReducer()
}
```

---

## 첫 Feature 만들기

### 예제: Counter Feature

간단한 카운터 Feature를 만들어봅시다.

#### Step 1: Reducer 정의

```swift
import ComposableArchitecture

@Reducer
struct CounterReducer {
    @ObservableState
    struct State: Equatable {
        var count = 0

        public init(count: Int = 0) {
            self.count = count
        }
    }

    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case resetButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none

            case .decrementButtonTapped:
                state.count -= 1
                return .none

            case .resetButtonTapped:
                state.count = 0
                return .none
            }
        }
    }
}
```

#### Step 2: View 작성

```swift
import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterReducer>

    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(store.count)")
                .font(.largeTitle)

            HStack(spacing: 16) {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    store.send(.resetButtonTapped)
                }
                .buttonStyle(.bordered)

                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
```

**View 규칙**:
- `store.send(action)` - Action 전송
- `store.state` - State 직접 접근 (SwiftUI가 자동 구독)

#### Step 3: Preview 추가

```swift
#Preview {
    CounterView(
        store: Store(
            initialState: CounterReducer.State(count: 5)
        ) {
            CounterReducer()
        }
    )
}
```

---

## 비동기 작업 추가

### API 호출이 있는 Counter

```swift
@Reducer
struct CounterReducer {
    @ObservableState
    struct State: Equatable {
        var count = 0
        var isLoading = false
        var factText: String?
    }

    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case fetchFactButtonTapped
        case factResponse(Result<String, Error>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none

            case .decrementButtonTapped:
                state.count -= 1
                return .none

            case .fetchFactButtonTapped:
                state.isLoading = true
                state.factText = nil

                // ✨ Effect로 비동기 작업
                return .run { [count = state.count] send in
                    do {
                        let url = URL(string: "http://numbersapi.com/\(count)")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let fact = String(decoding: data, as: UTF8.self)
                        await send(.factResponse(.success(fact)))
                    } catch {
                        await send(.factResponse(.failure(error)))
                    }
                }

            case .factResponse(.success(let fact)):
                state.isLoading = false
                state.factText = fact
                return .none

            case .factResponse(.failure):
                state.isLoading = false
                state.factText = "Failed to fetch fact"
                return .none
            }
        }
    }
}
```

### View 업데이트

```swift
struct CounterView: View {
    let store: StoreOf<CounterReducer>

    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(store.count)")
                .font(.largeTitle)

            HStack(spacing: 16) {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .buttonStyle(.borderedProminent)

                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .buttonStyle(.borderedProminent)
            }

            Button("Get Fact") {
                store.send(.fetchFactButtonTapped)
            }
            .buttonStyle(.bordered)
            .disabled(store.isLoading)

            if store.isLoading {
                ProgressView()
            } else if let fact = store.factText {
                Text(fact)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
    }
}
```

---

## Effect 종류

### 1. `.none` - 아무것도 안 함

```swift
case .incrementButtonTapped:
    state.count += 1
    return .none
```

### 2. `.run` - 비동기 작업

```swift
case .fetchData:
    return .run { send in
        let data = try await api.fetch()
        await send(.dataResponse(.success(data)))
    }
```

### 3. `.send` - 즉시 다른 Action 전송

```swift
case .loginSuccess:
    return .send(.navigateToHome)
```

### 4. `.merge` - 여러 Effect 동시 실행

```swift
case .onAppear:
    return .merge(
        .send(.fetchUser),
        .send(.fetchPosts)
    )
```

---

## 프로젝트 구조에 적용

### 실제 프로젝트에서 Feature 만들기

```
Projects/Feature/Counter/
├── Interface/Sources/Source.swift       # Public API
├── Sources/CounterReducer.swift         # 로직 구현
└── Sources/CounterView.swift            # View (internal)
```

**Interface/Sources/Source.swift**:
```swift
import ComposableArchitecture

@Reducer
public struct CounterReducer {
    public let reducer: Reduce<State, Action>

    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }

    @ObservableState
    public struct State: Equatable {
        public var count = 0

        public init(count: Int = 0) {
            self.count = count
        }
    }

    public enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
    }

    public var body: some ReducerOf<Self> {
        reducer
    }
}
```

**Sources/CounterReducer.swift**:
```swift
extension CounterReducer {
    public init() {
        self.init(reducer: Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none

            case .decrementButtonTapped:
                state.count -= 1
                return .none
            }
        })
    }
}
```

---

## 다음 단계

### 📚 더 배우기

1. **아키텍처 이해**
   - [아키텍처 개요](../Architecture/Overview.md) - 전체 구조
   - [Reducer 패턴](../Architecture/ReducerPattern.md) - Reducer 심화
   - [Dependency Injection](../Architecture/DependencyInjection.md) - 의존성 주입

2. **실전 가이드**
   - [네트워크 통신](./Guides/NetworkGuide.md) - API 호출
   - [NavigationStack](./Guides/NavigationStack.md) - 화면 전환
   - [테스트 작성](./Guides/Testing.md) - Reducer 테스트

3. **예제 분석**
   - [Auth Feature](./Examples/Auth.md) - 실제 로그인 Feature
   - [MainTab Feature](./Examples/MainTab.md) - 탭 구조

### 🛠️ 직접 해보기

1. Counter Feature에 다음 기능 추가:
   - [ ] 최소값/최대값 제한 (0-10)
   - [ ] 타이머로 자동 증가
   - [ ] UserDefaults에 count 저장

2. 새로운 Feature 만들기:
   - [ ] Todo List Feature
   - [ ] 네트워크 API 호출하는 Posts Feature

---

**작성일**: 2026-01-12
**예상 읽기 시간**: 10분
