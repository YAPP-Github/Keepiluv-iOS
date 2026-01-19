Rules

## 목적
팀 아키텍처 규칙과 결정사항을 간단하고 실행 가능한 형태로 정리합니다.

## DocC 문서화 기준
대상: Core / Domain / Feature / Shared 모듈의 Interface 계층

**문서화 대상**
- Interface의 public 타입(struct, enum, class 등)에 대한 간단한 설명 (필수)
- Shared의 경우 Interface가 없으므로 public 타입에 한해서 문서화 (필수)
- public 함수는 사용 예시 코드까지 작성 (필수)

**문서화 제외**
- enum case, 변수/프로퍼티: 문서화 주석 작성 안 함
- App 계층: internal 타입이므로 문서화 불필요
- Implementation 계층: public이 아닌 한 문서화 불필요

**엄격 적용**
- 문서화 제외 항목은 예외 없이 문서화를 금지합니다.
- public API(타입/함수) 문서화 누락은 규칙 위반입니다.

예시
```swift
/// 앱 전체에서 사용하는 네트워크 요청 프로토콜입니다.
///
/// ## 사용 예시
/// ```swift
/// let provider: NetworkProviderProtocol = NetworkProvider()
/// let user: User = try await provider.request(endpoint: UserEndpoint.profile)
/// ```
public protocol NetworkProviderProtocol {
    /// 공통 엔드포인트를 통해 서버에 데이터를 요청합니다.
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}
```

## Feature 모듈 구조
모든 Feature는 Interface / Implementation 분리 구조를 유지합니다.

```text
Feature
 ├── FeatureOnboarding
 ├── FeatureProfile
 ├── FeatureCrew
 └── Sources (Feature Root)
```

### 예외 Feature (App 직접 Path 관리)
- Auth / Onboarding / MainTab은 App에서 직접 Path를 관리하는 중간 관리자 Feature로 취급합니다.
- 위 Feature는 Interface/Implementation 분리 및 ViewFactory 강제 규칙에서 예외입니다.
- App은 위 Feature를 `makeView(_:)` 없이 직접 조립할 수 있습니다.
- 위 Feature는 내부 하위 Feature 조립 시 Implementation 모듈을 직접 import 할 수 있습니다.
- 위 Feature는 자식 Feature를 Interface-only `makeView(_:)` 대신 직접 생성할 수 있습니다.
- 그 외 Feature는 Interface 모듈만 import하며 `makeView(_:)` 또는 동등한 factory로만 조립합니다.

## Reducer 생성 규칙
- Interface에는 Reducer의 시그니처만 둡니다. (body는 외부 Reduce 주입)
- Implementation에서 실제 Reduce를 구성하는 init을 제공합니다.
- 다른 Feature에서 Reducer를 사용할 때는 Interface 타입만 의존합니다.

Interface 예시
```swift
@Reducer
public struct CounterReducer {
    let reducer: Reduce<State, Action>
    public init(reducer: Reduce<State, Action>) { self.reducer = reducer }
    public var body: some ReducerOf<Self> { reducer }
}
```

Implementation 예시
```swift
extension CounterReducer {
    public init() {
        self.init(reducer: Reduce { state, action in
            // 실제 로직
            return .none
        })
    }
}
```

## Feature Root에서의 조립
Feature Root(Sources)에서 각 Feature의 구현체를 조립합니다.

- Root가 구현 모듈을 직접 의존하고 Reducer/View를 주입합니다.
- 외부 모듈은 Interface에만 의존합니다.
- Feature Root에서 타입 재노출이 필요할 경우 **Interface 타입만 재노출**합니다.

## ViewFactory 도입 기준
기본 규칙: 모든 Feature에 강제하지 않습니다.

1) Flow 단위 Feature
- Flow 내부에서만 쓰이고 외부 재사용이 없다면 Root에서 직접 조립
- ViewFactory 생략 가능

2) 하위 기능 단위 Feature
- 다른 화면에서 재사용 가능성이 있으면 ViewFactory 도입
- Interface에 Factory 정의, Sources에서 liveValue 제공

## 의존성 주입 규칙 (필수)
Struct + closure + TCA Dependency 스타일을 기본으로 사용합니다.

- 모든 모듈은 TCA Dependency Container를 사용합니다.
- 계층 간 연결(Feature <-> Domain)은 Interface 모듈만 import합니다.
- liveValue는 Implementation 모듈에서 제공하며, 조립은 App/Feature Root에서 `.withDependency`로 명시합니다.
- Implementation 모듈 내부에서 다른 모듈의 의존성을 조립하지 않습니다.
- Core/Network, Core/Storage는 singleton을 사용하지 않고 TCA Dependency로 주입 가능한 인스턴스형으로 제공합니다.

Interface 예시
```swift
public struct DetailFactory: Sendable {
    public var makeView: @MainActor (StoreOf<DetailReducer>) -> AnyView
    public init(makeView: @escaping @MainActor (StoreOf<DetailReducer>) -> AnyView) {
        self.makeView = makeView
    }
}

extension DetailFactory: TestDependencyKey {
    public static let testValue = Self { _ in
        assertionFailure("DetailFactory.makeView is unimplemented")
        return AnyView(EmptyView())
    }
}
```

Sources 예시
```swift
extension DetailFactory: DependencyKey {
    public static let liveValue = Self { store in
        AnyView(DetailView(store: store))
    }
}
```

사용 예시
```swift
@Dependency(\.detailFactory) var detailFactory
detailFactory.makeView(store: store.scope(state: \.detail, action: \.detail))
```

## SwiftLint 규칙 (필수)
SwiftLint 경고를 가능한 한 최소화해야 합니다.

- 새로운 코드에서는 SwiftLint 경고가 발생하지 않도록 작성합니다.
- 변경으로 인해 경고가 증가하지 않도록 합니다.
- 불가피한 경우에만 제한적으로 `swiftlint:disable`을 사용하고, 범위를 최소화합니다.

## 코드 스타일 규칙 (필수)
메소드의 매개 변수가 2개 이상일 때는 개행하여 가독성을 높입니다.

예시
```swift
public func example(
    a: Int,
    b: Int
) -> ReturnType { ... }
```

## TCA Dependency + Interface 규칙 메모
Interface에 TestDependencyKey를 두면 MFA 규칙상 Testing 모듈 분리 원칙과 충돌 가능성이 있으므로,
팀 합의로 허용하거나 Testing 모듈로 대체하는 방안을 추후 결정합니다.
