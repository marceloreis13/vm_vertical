# Feature skeleton (copy this tree)

A `vm_*` module groups one or more features. Each feature is feature-first inside `src/`.

```
packages/vm_<module>/
  lib/
    vm_<module>.dart               # BARREL — only the public API
    src/
      <feature>/
        domain/
          <feature>_entity.dart     # entity + value objects
          failures.dart             # sealed Failure + Result<T>
          <feature>_repository.dart  # abstract interface
        data/
          <feature>_model.dart      # @JsonSerializable + mapper to entity
          <feature>_remote_data_source.dart
          <feature>_repository_impl.dart
        presentation/
          <feature>_cubit.dart      # cubit + sealed state
          screen/
            <feature>_screen.dart   # entry point: binds Cubit, composes Sections
          sections/
            <feature>_section.dart  # reads this feature's State; orchestrates Views
          views/
            <thing>_view.dart       # plain params + callbacks; candidate for promotion
          # see vm-ui-composition for how to split presentation/ by responsibility
      di/
        <module>_registration.dart  # registration fn receiving injected config
  example/                          # standalone runnable app (+ manipulable mocks)
  test/                             # unit / widget / golden
  pubspec.yaml
```

Barrel (`lib/vm_<module>.dart`) exports only what the outside may use:

```dart
// Public API of the module. Never export anything under src/ internals
// that consumers should not touch (mappers, datasources, models).
export 'src/<feature>/domain/<feature>_entity.dart';
export 'src/<feature>/domain/failures.dart' show Failure, Result;
export 'src/<feature>/presentation/<feature>_cubit.dart';
export 'src/<feature>/presentation/screen/<feature>_screen.dart';
export 'src/di/<module>_registration.dart' show register<Module>Module, <Module>Config;
```

The reference files `domain.dart`, `data.dart`, `presentation.dart` and `registration.dart`
in this folder show the four layers for a sample `Article` feature. In a real module, split
them into the files above (one concern per file, Screen/Sections/Views each in their own
folder — see `vm-ui-composition`).
