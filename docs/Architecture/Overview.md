# 아키텍처 개요

> 프로젝트의 전체 구조와 설계 철학

## 목차

1. [전체 구조](#전체-구조)
2. [계층별 역할](#계층별-역할)
3. [핵심 원칙](#핵심-원칙)
4. [데이터 흐름](#데이터-흐름)

---

## 전체 구조

```
Projects/
├── App/                        # 앱 진입점
│   ├── Sources/
│   │   ├── TwixApp.swift      # @main
│   │   ├── AppRootReducer.swift
│   │   └── AppRootView.swift
│   └── Resources/
│
├── Feature/                    # 기능 모듈 (UI + 비즈니스 로직)
│   ├── Auth/
│   ├── Onboarding/
│   ├── MainTab/
│   └── Sources/               # Feature Root
│
├── Domain/                     # 도메인 로직
│   └── Auth/
│
├── Core/                       # 핵심 인프라
│   ├── Network/
│   └── Logging/
│
└── Shared/                     # 공통 유틸
    ├── DesignSystem/
    └── ThirdPartyLib/
```

---

## 계층별 역할

### App 계층
- 앱의 진입점 (`@main`)
- Feature들을 조립하여 최종 앱 구성
- AppRootReducer에서 화면 전환 관리

### Feature 계층
- UI + 비즈니스 로직
- Interface/Sources 분리
- 독립적으로 실행 가능 (Example 타겟)

### Domain 계층
- 도메인 모델 (Entity, VO)
- 비즈니스 규칙
- Feature와 독립적

### Core 계층
- 네트워크, 로깅 등 인프라
- Feature에서 사용하는 공통 기능

### Shared 계층
- 디자인 시스템
- 써드파티 라이브러리 래핑

---

## 핵심 원칙

### 1. Interface/Implementation 분리

```
Feature/Auth/
├── Interface/Sources/          # 타입 정의만 (public)
└── Sources/                    # 실제 구현 (internal)
```

**장점**:
- 빌드 시간 최적화
- 의존성 최소화
- 테스트 용이

**예외**:
- Auth / MainTab / Onboarding은 App에서 직접 Path를 관리하는 중간 관리자 Feature로 취급합니다.
- 위 Feature는 Interface/Implementation 분리 규칙을 강제하지 않습니다.

### 2. Dependency Injection

모든 의존성은 TCA Dependency로 주입:
```swift
@Dependency(\.authLoginClient) var authLoginClient
```

### 3. ViewFactory 패턴

View를 직접 노출하지 않고 Factory로 생성:
```swift
@Dependency(\.authViewFactory) var authViewFactory
authViewFactory.makeView(store)
```

---

## 데이터 흐름

```
사용자 → View → Action → Reducer → State 변경 → View 업데이트
                   ↓
              Effect (비동기 작업)
                   ↓
              새로운 Action
```

**예시: 로그인 플로우**

```
1. 사용자가 "Apple로 로그인" 버튼 탭
   ↓
2. AuthView: store.send(.appleLoginButtonTapped)
   ↓
3. AuthReducer: state.isLoading = true
   ↓
4. Effect: authLoginClient.login(.apple)
   ↓
5. 성공 시: send(.loginResponse(.success(result)))
   ↓
6. AuthReducer: return .send(.delegate(.loginSucceeded))
   ↓
7. AppRootReducer: state.path = .mainTab(...)
   ↓
8. MainTabView 렌더링
```

---

## 다음 단계

- [Reducer 패턴](./ReducerPattern.md) - Reducer 구현 방법
- [Dependency Injection](./DependencyInjection.md) - 의존성 주입
- [ViewFactory 패턴](./ViewFactory.md) - ViewFactory 구현
- [팀 규칙](../../Rules.md) - 팀 합의사항

---

**작성일**: 2026-01-12
