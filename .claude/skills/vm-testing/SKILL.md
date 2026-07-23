---
name: vm-testing
description: Use when writing or reviewing tests for a vm_* module or app feature — unit tests for domain/repositories, widget/bloc tests for presentation, and golden tests for vm_storyboard components. Apply whenever adding or changing code that needs tests, and during OpenSpec /opsx:apply.
metadata:
  author: vm_core
  version: "1.0"
---

# Testing (vm_core)

How every module is tested. Complements `vm-clean-architecture` (layers), `vm-dart-idioms`
(how to write it), `vm-ddd-modular` (domain) and `vm-ui-composition` (Screen/Sections/Views).
Copy from `references/sample_test.dart`.

## Test per layer

- **domain** → unit tests. Pure Dart, no Flutter binding. Test entities/value objects
  (validation, equality) and use cases/domain services.
- **data** → unit tests. Test repository implementations with a **fake** datasource: verify
  model→entity mapping and that IO errors become the right domain `Failure` (Result is `Err`).
- **presentation** → widget/bloc tests. Test the Cubit with `bloc_test` (emitted state
  sequence) using a fake repository. Within presentation, the test shape follows the
  responsibility tier (see `vm-ui-composition`):
  - **Views** → `flutter_test`, pumped standalone with plain constructor args — no
    `BlocProvider`, no fake Cubit. This is the natural golden-test surface.
  - **Sections** → `flutter_test`, pumped with a fake/mocked Cubit via `BlocProvider.value`,
    exercising each `State` variant (loading/loaded/error/...). Assert composition given
    state, and Cubit events dispatched on interaction.
  - **Screen** → a couple of shallow integration widget tests with a fake Cubit, confirming
    Sections are wired correctly. Not an exhaustive golden surface.
- **vm_storyboard components** → **golden tests** (`matchesGoldenFile`), covering light/dark
  themes and key states (loading/empty/error).

## Conventions

- `test/` mirrors `lib/src/`: `test/<feature>/domain/..._test.dart`, etc.
- Name files `<subject>_test.dart`; name cases by behavior: `test('returns Err on timeout', ...)`.
- Arrange / Act / Assert, one behavior per test. No logic in tests.
- Prefer **fakes** (hand-written, in `test/fakes/`) over mocks. Use `mocktail` only when a mock
  is clearly simpler; never `mockito` codegen.
- Tests use the **public API (barrel)** where possible; reach into `src/` only for pure units.
- Every scenario in the change's spec should map to at least one test.

## Do / Don't

- DO test the repository's error mapping (each IO failure → the intended domain `Failure`).
- DO assert the full state sequence of a Cubit with `bloc_test` (`expect: [...]`).
- DO cover golden states for both themes (default and an overridden palette).
- DO keep `domain` tests free of `flutter_test` / `WidgetTester`.
- DON'T hit real network/storage; inject fakes.
- DON'T assert on private implementation details; assert on observable behavior.
- DON'T commit failing or skipped goldens; regenerate intentionally with `--update-goldens`.

## Checklist

- [ ] Each layer has its tests (unit domain/data, widget/bloc presentation, golden components).
- [ ] `test/` mirrors `src/`; files `*_test.dart`; behavior-named cases.
- [ ] Repository error mapping is covered (Result `Err` with the right `Failure`).
- [ ] Cubit state sequence covered with `bloc_test`; widgets pumped with a fake Cubit.
- [ ] Goldens cover key states in both themes; no real IO anywhere.
- [ ] Every spec scenario maps to a test.

## References

- `references/sample_test.dart` — unit (domain + repository), bloc test (cubit), and golden.
