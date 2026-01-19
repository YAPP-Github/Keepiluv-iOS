# Claude Code 가이드

> 이 파일은 Claude Code CLI에서 프로젝트 맥락을 빠르게 파악하기 위한 가이드입니다.

## 📌 빠른 참조

- [팀 규칙](./Rules.md) - 반드시 지켜야 할 팀 합의사항

---

## 🎯 프로젝트 요약

- **아키텍처**: SwiftUI + TCA + Micro Features Architecture
- **빌드 시스템**: Tuist
- **핵심 원칙**: Interface/Implementation 분리, Dependency Injection, ViewFactory 패턴, TokenManager 단일 중재(직접 TokenStorage 접근 금지)

---

## 📚 문서 구조

모든 문서는 **docs/** 폴더에 계층적으로 구성되어 있습니다.

### 처음 배울 때
1. [빠른 시작](./docs/QuickStart.md) - TCA 기본 개념 (10분)
2. [아키텍처 개요](./docs/Architecture/Overview.md) - 전체 구조

### Feature 개발할 때
1. [팀 규칙](./Rules.md) - DocC, Reducer, ViewFactory 규칙
2. [네트워크 통신](./docs/Guides/NetworkGuide.md) - API 호출
3. [NavigationStack](./docs/Guides/NavigationStack.md) - 화면 전환

### 코드 작성 시 참고
1. [네이밍 규칙](./docs/Reference/NamingConventions.md) - Action, File 네이밍
2. [체크리스트](./docs/Reference/Checklists.md) - Feature 구현 체크리스트
3. [파일 구조화 규칙](./docs/Reference/FileOrganization.md) - 파일 분리 및 구조화

---

## 🏗️ 현재 구현된 Feature

### Auth Feature
- **위치**: `Projects/Feature/Auth/`
- **역할**: Apple 로그인
- **플로우**: 로그인 성공 → `.delegate(.loginSucceeded)` → MainTab 전환

### MainTab Feature
- **위치**: `Projects/Feature/Sources/`
- **역할**: 메인 탭 화면 (홈/통계/커플/마이페이지)

---

## 🔧 자주 사용하는 명령어

### Tuist
```bash
tuist generate    # 프로젝트 생성
tuist install     # 의존성 설치
tuist clean       # 캐시 정리
```

### Git
```bash
# 커밋 규칙
feat: 새로운 기능 추가
fix: 버그 수정
refactor: 코드 리팩토링
chore: 빌드 설정, 패키지 등
docs: 문서 수정
```

---

## 📖 상세 문서 찾기

모든 상세 문서는 [README.md](./README.md#-문서-구조)에서 찾을 수 있습니다.

### 아키텍처
- [아키텍처 개요](./docs/Architecture/Overview.md)
- [Interface/Implementation 분리](./docs/Architecture/InterfaceImplementation.md)
- [Reducer 패턴](./docs/Architecture/ReducerPattern.md)
- [Dependency Injection](./docs/Architecture/DependencyInjection.md)
- [ViewFactory 패턴](./docs/Architecture/ViewFactory.md)

### 가이드
- [빠른 시작](./docs/QuickStart.md)
- [네트워크 통신](./docs/Guides/NetworkGuide.md)
- [NavigationStack](./docs/Guides/NavigationStack.md)
- [복잡한 State 관리](./docs/Guides/StateManagement.md)
- [테스트 작성](./docs/Guides/Testing.md)

### 레퍼런스
- [네이밍 규칙](./docs/Reference/NamingConventions.md)
- [체크리스트](./docs/Reference/Checklists.md)
- [파일 구조화 규칙](./docs/Reference/FileOrganization.md)

### 예제
- [Auth Feature](./docs/Examples/Auth.md)
- [MainTab Feature](./docs/Examples/MainTab.md)

---

## 💡 Claude Code 사용 팁

### 작업 시작 전
```
"README.md 읽고 [작업 내용] 해줘"
"docs/Guides/NetworkGuide.md 참고해서 API Client 만들어줘"
```

### 규칙 확인
```
"Rules.md 기반으로 Feature 만들어줘"
```

### 코드 리뷰
```
"Auth Feature 코드 리뷰해줘"
"이 Reducer가 Rules.md 규칙을 잘 따르는지 확인해줘"
```

---

## 🗂️ 구버전 문서

- `Claude_OLD.md` - 계층화 이전의 모놀리식 문서 (백업용)

---

**문서 버전**: 2.0 (계층적 구조)
**마지막 업데이트**: 2026-01-12
**작성자**: Claude Code Assistant

---

## 📝 참고사항

이 문서는 Claude Code가 프로젝트 맥락을 빠르게 파악하기 위한 **요약본**입니다.

**상세 내용은 각 문서를 참고하세요:**
- 전체 개요: [README.md](./README.md)
- 팀 규칙: [Rules.md](./Rules.md)
- 가이드: [docs/](./docs/)
