# Feature 구현 체크리스트

## Interface 구현

- [ ] State struct 정의 (public)
- [ ] State.init() 정의 (public)
- [ ] Action enum 정의 (public)
- [ ] Reducer struct 정의 (public)
- [ ] Client struct 정의 (필요 시)
- [ ] ViewFactory struct 정의 (필요 시)
- [ ] TestDependencyKey 구현
- [ ] DependencyValues 확장

## Sources 구현

- [ ] Reducer.init() 구현 (public)
- [ ] Reducer body 로직 작성
- [ ] View 구현 (internal)
- [ ] Client liveValue 구현
- [ ] ViewFactory liveValue 구현
- [ ] DocC 문서 작성

## 테스트

- [ ] Reducer 유닛 테스트
- [ ] Client Mock 구현
- [ ] Integration 테스트
- [ ] Preview 작성 (Live, Mock, Error)

---

**작성일**: 2026-01-12
