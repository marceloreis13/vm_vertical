# Module scaffold

Every `vm_*` package under `packages/` follows this standalone layout:

```
packages/vm_x/
  lib/
    vm_x.dart          # barrel: the only public entry point
    src/
      presentation/    # Cubits, states, widgets — feature-first, split by
                       # responsibility into screen/ sections/ views/
                       # (see conventions.md, "UI composition")
      domain/          # entities, value objects, repository interfaces
      data/            # repository impls, data sources, DTOs, mappers
  example/              # standalone runnable app
  test/
    unit/
    widget/
    golden/
  pubspec.yaml
```

- `lib/vm_x.dart` is the only file other packages/apps may import
  (`package:vm_x/vm_x.dart`). See [conventions.md](conventions.md#barrel-pattern).
- `pubspec.yaml` sets `resolution: workspace` and is added to the root
  `workspace:` list.

## `example/`

Every module ships an `example/` that **compiles and runs standalone**,
without depending on any app under `apps/`.

- If the module needs external inputs (API responses, tokens, device data),
  `example/` supplies **mocked data that is easy to tweak** — plain constants
  or a small fixtures file, not a hidden fixture buried in test helpers — so a
  developer can open the example and experiment immediately.
- **Infrastructure modules with no UI of their own** (e.g. `vm_network`,
  `vm_navigation`) still need a *visual* example: a small screen that drives
  the module and shows its behavior (e.g. a button that fires a mocked
  request and displays the resulting state), not a bare `main()` with no
  visible output.
- **The demo screen itself lives in `lib/`, not in `example/`, and is
  exported by the barrel.** `example/lib/main.dart` is only a thin runnable
  shell: it registers the module (with mock config) and calls
  `runApp(...)` on that screen — it does not contain the demo UI. This lets
  any other app (notably `app_showcase`, see `17-app-showcase.md`) import
  and embed the same screen via `package:vm_x/vm_x.dart`, with no
  dependency on another package's `example/` and no duplicated demo code.
  Validated by `vm_storyboard`'s `GalleryScreen`, which also doubles as the
  golden-test baseline.

## `test/`

Every module scaffolds all three test kinds from the start:

- `unit/` — domain logic, repositories, mappers, use cases.
- `widget/` — Cubit-driven widgets and pages.
- `golden/` — visual regression for presentation components (see
  `vm_storyboard` once available).

## DI registration

The barrel also exposes the module's registration function (GetIt +
Injectable), receiving its config from the consuming app. See
[conventions.md](conventions.md#dependency-injection-getit--injectable).

## Practical notes (validated by `vm_storyboard`)

- **`data/` can stay empty.** A module with no IO of its own (e.g. a pure
  presentation/design-system module) has nothing to put under `data/`. Don't
  force a repository/datasource pair that has no real data source.
- **Freezed and `ThemeExtension` don't mix.** Freezed generates `copyWith`
  as a getter (for its fluent copy-with builder); `ThemeExtension.copyWith`
  must be a method. Combining `@freezed` with `extends ThemeExtension<T>`
  fails analysis with `inconsistent_inheritance_getter_and_method`. Write
  the `ThemeExtension` subclass as a plain `@immutable` class with a manual
  `copyWith`/`lerp`/`==`/`hashCode` instead; nested value objects it holds
  can still be `@freezed`.
- Injectable's codegen isn't mandatory for every module. A simple
  config→singleton registration (no internal dependency graph to wire) can
  be a plain imperative function using `getIt.registerSingleton<T>(...)`
  directly, per the same "single registration entry point" contract.
