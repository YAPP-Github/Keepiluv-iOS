# Feature 구현 체크리스트

> Feature를 구현할 때 빠뜨리지 말아야 할 항목들

## Interface 구현 체크리스트

### Reducer

- [ ] `@Reducer` 매크로 추가
- [ ] `public struct {Feature}Reducer` 정의
- [ ] `public let reducer: Reduce<State, Action>` 프로퍼티
- [ ] `public init(reducer: Reduce<State, Action>)` 생성자
- [ ] `public var body: some ReducerOf<Self> { reducer }` 구현

### State

- [ ] `@ObservableState` 매크로 추가
- [ ] `public struct State: Equatable` 정의
- [ ] 모든 프로퍼티 `public` 선언
- [ ] `public init()` 생성자 정의 ⚠️ **필수!**

### Action

- [ ] `public enum Action` 정의
- [ ] 사용자 액션 정의 (`Tapped/Changed` 접미사)
- [ ] 시스템 응답 정의 (`Response` 접미사)
- [ ] Delegate 액션 정의 (필요 시)

### Delegate (필요 시)

- [ ] `@CasePathable` 매크로 추가
- [ ] `public enum Delegate` 정의
- [ ] Delegate 케이스 정의

### Client (필요 시)

- [ ] `public struct {Domain}Client` 정의
- [ ] 메서드 프로퍼티 정의 (`@Sendable` 클로저)
- [ ] `public init` 생성자 정의
- [ ] `TestDependencyKey` extension 추가
- [ ] `DependencyValues` extension 추가

### ViewFactory (필요 시)

- [ ] `public struct {Feature}ViewFactory: Sendable` 정의
- [ ] `public var makeView: @MainActor (_ store:) -> AnyView` 정의
- [ ] `public init` 생성자 정의
- [ ] `TestDependencyKey` extension 추가
- [ ] `DependencyValues` extension 추가

---

## Sources 구현 체크리스트

### Reducer 로직

- [ ] `extension {Feature}Reducer` 작성
- [ ] `public init()` 구현 (기본 생성자)
- [ ] `@Dependency` 주입
- [ ] `self.init(reducer: Reduce { ... })` 호출
- [ ] 모든 Action에 대한 case 처리
- [ ] State 변경 후 Effect 반환

### View

- [ ] `struct {Feature}View: View` 정의 ⚠️ **internal**
- [ ] `let store: StoreOf<{Feature}Reducer>` 프로퍼티
- [ ] `var body: some View` 구현
- [ ] `store.send(action)` 호출
- [ ] `store.state` 직접 접근

### Client 구현 (필요 시)

- [ ] `extension {Domain}Client: DependencyKey` 작성
- [ ] `public static let liveValue` 구현
- [ ] 실제 로직 구현 (네트워크, DB 등)

### ViewFactory 구현 (필요 시)

- [ ] `extension {Feature}ViewFactory: DependencyKey` 작성
- [ ] `public static let liveValue` 구현
- [ ] `AnyView({Feature}View(store: store))` 반환

### Linker (Static Library인 경우)

- [ ] `public enum Feature{Name}Linker` 정의
- [ ] `public static func link()` 구현
- [ ] 모든 `liveValue` 강제 참조

---

## 문서화 체크리스트

### DocC 주석

- [ ] public 타입에 `///` 주석 추가
- [ ] 간단 설명 (1-2문장)
- [ ] `## 사용 예시` 섹션 추가
- [ ] 코드 블록 (```swift```) 추가
- [ ] 복잡한 로직은 `## 동작 원리` 섹션 추가

### 예시

```swift
/// 소셜 로그인을 처리하는 클라이언트입니다.
///
/// Apple, Kakao 등의 소셜 로그인 제공자를 통해 사용자 인증을 수행합니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.authLoginClient) var authLoginClient
/// let result = try await authLoginClient.login(.apple)
/// ```
public struct AuthLoginClient { }
```

---

## Preview 체크리스트

- [ ] `#Preview("Live")` - 실제 동작
- [ ] `#Preview("Mock - 성공")` - Mock 데이터
- [ ] `#Preview("Mock - 에러")` - 에러 상태
- [ ] `#Preview("Loading")` - 로딩 상태
- [ ] `#Preview("Empty")` - 빈 상태 (필요 시)

### 예시

```swift
#Preview("Live") {
    AuthView(
        store: Store(initialState: AuthReducer.State()) {
            AuthReducer()
        }
    )
}

#Preview("Mock - 성공") {
    AuthView(
        store: Store(initialState: AuthReducer.State()) {
            AuthReducer()
        } withDependencies: {
            $0.authLoginClient = .mockSuccess
        }
    )
}
```

---

## 테스트 체크리스트

### Reducer 테스트

- [ ] `@Test` 함수 작성
- [ ] `TestStore` 생성
- [ ] `withDependencies` Mock 주입
- [ ] `await store.send(action)` - Action 전송
- [ ] State 변경 검증
- [ ] `await store.receive(action)` - Effect 응답 검증
- [ ] 최종 State 검증

### Client Mock

- [ ] `mockSuccess` 구현
- [ ] `mockFailure` 구현
- [ ] 다양한 시나리오 Mock (필요 시)

---

## Tuist 프로젝트 설정 체크리스트

### Project.swift

- [ ] `.feature(interface:)` 타겟 정의
- [ ] `.feature(implements:)` 타겟 정의
- [ ] `.feature(example:)` 타겟 정의 (필요 시)
- [ ] `.feature(testing:)` 타겟 정의 (필요 시)
- [ ] 의존성 정확히 설정

### 의존성 규칙

```swift
// Interface는 최소 의존성만
.feature(interface: .auth, config: .init(
    dependencies: [
        .external(dependency: .ComposableArchitecture)
    ]
))

// Sources는 Interface + 필요한 모듈
.feature(implements: .auth, config: .init(
    dependencies: [
        .feature(interface: .auth),
        .core(implements: .logging),
        .external(dependency: .ComposableArchitecture)
    ]
))
```

---

## 코드 리뷰 체크리스트

### 아키텍처

- [ ] Interface/Sources 분리 올바른가?
- [ ] public/internal 접근 제어자 올바른가?
- [ ] Dependency 올바르게 주입했는가?
- [ ] Reducer는 순수 함수인가? (Side Effect 없는가?)

### 네이밍

- [ ] Action은 "What happened" 형태인가?
- [ ] 사용자 액션은 `Tapped/Changed` 접미사 사용했는가?
- [ ] Bool 프로퍼티는 `is/has/should` 접두사 사용했는가?
- [ ] 약어 사용하지 않았는가?

### State 관리

- [ ] State는 최소한인가? (계산 가능한 것은 computed property)
- [ ] State는 `Equatable`인가?
- [ ] Optional은 적절히 사용했는가?

### Effect

- [ ] 비동기 작업은 `.run`으로 래핑했는가?
- [ ] Effect는 적절한 시점에 반환되는가?
- [ ] Effect 취소가 필요한 경우 `.cancellable(id:)` 사용했는가?

### 에러 처리

- [ ] 모든 네트워크 에러 처리했는가?
- [ ] 사용자에게 에러 메시지 표시하는가?
- [ ] Retry 로직이 필요한가?

---

## 배포 전 최종 체크리스트

- [ ] 모든 테스트 통과
- [ ] SwiftLint 경고 없음
- [ ] 불필요한 로그 제거
- [ ] 주석 처리된 코드 제거
- [ ] TODO 주석 확인
- [ ] DocC 문서 완성
- [ ] Example 앱 정상 동작
- [ ] Preview 모두 정상 렌더링

---

**작성일**: 2026-01-12
