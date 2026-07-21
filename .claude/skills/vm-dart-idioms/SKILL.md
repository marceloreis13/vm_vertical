---
name: vm-dart-idioms
description: Use when writing or refactoring Dart code in this project — applying modern idiomatic Dart (Dart 3.x): sound null-safety, sealed classes with exhaustive pattern matching and switch expressions, records, immutability, extension methods, effective async with Future/Stream, and idiomatic collections. Apply during OpenSpec /opsx:apply and any Dart coding.
metadata:
  author: vm_core
  version: "1.0"
---

# Dart idioms (vm_core)

Get the most out of modern Dart (3.x). Pair with `vm-clean-architecture` (structure) and
`vm-ddd-modular` (domain modeling). Copy patterns from `references/idioms.dart`.

## Principles

### Null-safety
- Prefer non-nullable types. Reach for `?` only when absence is meaningful.
- Avoid `!` (bang). Narrow with `if (x case final v?)`, `?.`, `??`, or early return.
- Use `late` only for genuine deferred-but-non-null init, not to dodge the type system.

### Sealed classes + pattern matching
- Model closed sets (states, results, variants) as `sealed class` unions (or Freezed unions).
- Consume them with **exhaustive** `switch` expressions. No `default` on a sealed type — let
  the compiler force you to handle new cases.
- Destructure with patterns: `switch (r) { Ok(:final value) => ..., Err(:final failure) => ... }`.

### Records
- Use records for small, local, unnamed groupings and multiple return values:
  `(=> (int count, String label))`. Do **not** use records as domain models — those are
  entities/value objects (see `vm-ddd-modular`).

### Immutability
- Everything data-shaped is immutable: `final` fields, `const` constructors where possible.
- Models/entities/state via Freezed. Never expose mutable collections; return `List.unmodifiable`
  or `Iterable`.

### Extensions
- Use extensions to add behavior/readability (mappers, small helpers) without inheritance.
- Keep them narrow and discoverable. Do not hide heavy logic or IO in an extension.

### Async
- `async`/`await` over raw `.then`. Return `Future<Result<T>>`, do not throw across boundaries.
- Use `Stream` for continuous values; expose broadcast streams from Cubits/services when needed.
- Parallelize independent awaits with `Future.wait`.

### Collections
- Prefer collection-if / collection-for / spreads over imperative building.
- Chain `map`/`where`/`fold`; materialize with `.toList()` only at the edge.

## Do / Don't

- DO make illegal states unrepresentable with sealed unions + exhaustive switches.
- DO prefer expression-bodied members (`=>`) for simple returns.
- DO use `const` aggressively (widgets, value objects, literals).
- DON'T use `dynamic`; use generics or a precise type. `Object?` if truly unknown.
- DON'T use `!` to silence null; handle the null case.
- DON'T add a `default:`/`_ =>` to a sealed switch just to compile — handle every case.
- DON'T mutate shared state; return new immutable values.

## Checklist

- [ ] No `dynamic`; no unjustified `!` or `late`.
- [ ] Closed sets are sealed unions consumed by exhaustive switches (no `default`).
- [ ] Data types are immutable (`final`/`const`/Freezed); no leaked mutable collections.
- [ ] Async returns `Result<T>`; independent awaits use `Future.wait`.
- [ ] Records used only for local groupings, not domain models.

## References

- `references/idioms.dart` — compact, copyable examples of each idiom.
