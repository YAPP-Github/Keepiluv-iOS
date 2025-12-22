# make module Flow

이 문서는 `GenerateModule.swift`를 기준으로  
새로운 모듈이 생성되는 전체 흐름과 규칙을 설명합니다.

이 가이드는 Tuist의 `make module` 자동화 플로우를 이해하고,
모듈 구조를 일관되게 유지하기 위한 기준 문서입니다.

모듈 생성은 단순한 파일 추가가 아니라,
프로젝트 전체 아키텍처 규칙을 따르는 작업입니다.

`GenerateModule.swift`는 다음을 자동으로 수행합니다.

- 모듈 디렉터리 생성
- Tuist Template 기반 스캐폴드 생성
- `Module.swift`에 모듈 등록
- 타겟 의존성 규칙 자동 구성
- `Project.makeModule` 기반 `Project.swift` 생성

이를 통해 **타겟 이름, 경로, 의존성 규칙을 코드 수준에서 강제**합니다.

---

## Step 1. 사용자 입력

스크립트 실행 시 다음 정보를 입력받습니다.

### Layer
- Feature / Domain / Core / Shared
- 모듈의 책임과 위치를 결정합니다.

### Module Name
- 모듈의 실제 이름입니다.
- 타겟 이름, 폴더 이름, `Module` enum에 모두 사용됩니다.

### Author / Date
- 템플릿 파일 헤더에 사용됩니다.

### Options
- Unit Tests 여부
- Interface 타겟 여부  
  - Shared는 Interface를 생성하지 않습니다.
- Feature 레이어의 경우 Example 타겟 여부

---

## Step 2. Module 등록

선택한 Layer에 따라 `Module.swift`에 새로운 case를 추가합니다.

```swift
enum Feature {
    case onboarding = "Onboarding"
}
```

## Step 3. Project 디렉터리 생성
- Projects/{Layer}/{ModuleName}

- 예시: Projects/Feature/Onboarding


이 디렉터리는 이후 생성되는 모든 파일의 기준 경로가 됩니다.

## Step 4. Micro Target 스캐폴드

옵션에 따라 다음 템플릿이 생성됩니다.

- Sources (항상 생성)

- Interface (Shared 제외)

- Tests / Testing

- Example (Feature 전용)

각 타겟은 Tuist Template을 통해 생성됩니다.

## Step 5. Target 의존성 구성
![](dependency)

## Step 6. Project.swift 생성
```swift
let project = Project.makeModule(
    name: Module.Feature.name + Module.Feature.onboarding.rawValue,
    targets: [
        .feature(
            implements: .onboarding,
            config: .init()
        )
    ]
)
```

문자열 기반 타겟 정의를 사용하지 않습니다.

모든 타겟은 Target+(App/Core/Domain/Feature/Shared).swift를 통해 생성됩니다.

## 생성되는 기본 구조
![](tree)
