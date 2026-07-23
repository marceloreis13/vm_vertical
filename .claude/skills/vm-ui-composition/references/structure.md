# Presentation skeleton (copy this tree)

Inside a feature's `presentation/`, split by responsibility (Screen / Sections / Views), not
by size:

```
presentation/<feature>/
  <feature>_cubit.dart          # cubit + sealed state (see vm-clean-architecture)
  screen/
    <feature>_screen.dart       # entry point: binds Cubit, composes Sections
  sections/
    <feature>_form_section.dart # reads this feature's State; orchestrates Views
    <feature>_list_section.dart
  views/
    <thing>_view.dart           # plain params + callbacks; candidate for promotion
```

- `screen/` has exactly one entry point per feature (occasionally a second, for a small
  secondary screen of the same feature).
- `sections/` and `views/` can each have as many files as the feature needs; there is no
  minimum.
- A feature with a single, simple screen and no reusable pieces may have an empty `views/`
  — that's fine, don't invent a View to fill the folder.

See the parent `SKILL.md` for how to decide which tier a new widget belongs to, and the
promotion rule for Views that repeat across features.
