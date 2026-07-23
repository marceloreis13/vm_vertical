---
name: vm-ui-composition
description: Use when structuring the presentation layer of a vm_* module or app feature — organizing a feature's widgets into Screen/Sections/Views by responsibility, deciding where a new widget belongs, and promoting reusable widgets to vm_storyboard or a shared package. Apply when creating a new feature's presentation/ folder, adding a widget, or reviewing where a widget should live.
metadata:
  author: vm_core
  version: "1.0"
---

# UI composition (vm_core)

How every feature organizes its widgets inside `presentation/<feature>/`. Complements
`vm-clean-architecture` (layers) and `vm-testing` (test strategy per tier). Copy the tree in
`references/structure.md`.

## The three tiers

Every widget in a feature's presentation code plays exactly one role — decided by
**responsibility, never by size**:

### Screen — entry point
- One per feature (occasionally a couple, for a feature with a secondary screen).
- Binds the Cubit (`BlocProvider`/`BlocBuilder` at the top), composes Sections, wires
  navigation. No visual logic of its own beyond arranging Sections.
- Lives in `presentation/<feature>/screen/`.

### Sections — compose a slice of this screen's flow
- Answers "what happens in this part of THIS screen." Owns coordination logic specific to
  this feature: which Views appear together, when to show an error banner, ordering.
- Reads this feature's `State` (or a slice of it) directly — it exists because this flow
  exists, not before it.
- **Never** promoted to another feature or to `vm_storyboard`. If two features seem to share
  a whole Section, the shared part is almost always a View underneath, not the Section
  itself.
- Lives in `presentation/<feature>/sections/`.

### Views — resolve a reusable UI pattern
- Answers "how does this piece of UI behave," not "why is it here." Takes plain
  parameters/callbacks — never touches this feature's `State`, `Cubit`, a repository, or any
  IO.
- May take a domain type as a parameter (`UserTile({required User user})`) without becoming
  feature-specific — it doesn't know *why* a `User` is being shown, only how to show one.
- **Test**: could this exact widget be lifted into a different feature that has an analogous
  concept, unchanged? If yes, it's a View.
- Lives in `presentation/<feature>/views/`.

## Input fields must declare the right keyboard

Every text input — in `vm_storyboard` or in a feature's own Views — must set
`keyboardType`/`textInputAction` (or platform equivalent) to match what the field actually
collects. This is never optional and never left at the default text keyboard "because it still
works":

- Email → `TextInputType.emailAddress`. Phone → `TextInputType.phone`. Numeric-only (amount,
  quantity, OTP) → `TextInputType.number`. URL → `TextInputType.url`. Multiline (notes,
  description) → `TextInputType.multiline`.
- The keyboard's action button must match what happens next: `TextInputAction.search` for a
  search field, `.done` for the last field in a form, `.next` for a field followed by another.
- A **generic** field (`VmTextField`-shaped: reusable, no fixed purpose) exposes
  `keyboardType`/`textInputAction` as parameters and leaves the caller to set them — it cannot
  guess the purpose. A **purpose-built** field (`VmSearchField`-shaped: the purpose is baked
  into the widget's name) hard-codes the right keyboard/action itself; it does not make the
  caller repeat a decision the widget already knows the answer to.
- Getting this wrong is a correctness bug, not a polish item: the wrong keyboard measurably
  slows down or blocks real users (e.g. no `@`/`.` row for an email field on some keyboards).

## The promotion rule

A View that repeats — verbatim or near-verbatim — in a second feature MUST be promoted, not
copy-pasted:

- **Fully generic, no business meaning** (a button variant, a field shape) → `vm_storyboard`.
- **App-specific but reused across features** (e.g. a `UserTile` shaped around this app's
  `User` entity) → a shared package/folder for that app, never a direct feature-to-feature
  import.

Cross-feature imports between `presentation/<feature_a>/` and `presentation/<feature_b>/` are
not allowed, the same way `src/` internals may not leak outside a package's barrel — if you
need one, promote instead.

## Deciding where a new widget goes

Ask, in this order:

1. Does it read this feature's `Cubit`/`State`, or coordinate other widgets based on it? →
   **Section**.
2. Does it only take constructor parameters and callbacks, with no knowledge of *why* it's
   being shown? → **View**.
3. Is it the single top-level widget that binds the Cubit and lays out Sections? → **Screen**.

If you catch yourself asking "is this big enough to be a Section," that's the wrong
criterion — responsibility decides the tier, not size or line count.

## Testing per tier

See `vm-testing` for the full test conventions; per-tier summary:

- **Views** — `flutter_test`, pumped standalone with plain constructor args, no
  `BlocProvider` and no fake Cubit. The natural surface for golden tests: appearance is
  deterministic given props.
- **Sections** — `flutter_test`, pumped with a fake/mocked Cubit exposing different `State`
  values (loading/loaded/error/...) via `BlocProvider.value`. Assert that a given state
  produces the right child composition, and that an interaction dispatches the right Cubit
  event. Not primarily a golden-test surface — the value is in orchestration, not pixels.
- **Screen** — a couple of shallow integration widget tests: pump the whole screen with a
  fake Cubit, confirm Sections are wired correctly. No exhaustive golden coverage here; it is
  expensive and brittle at this size.

If a View's test needs a mocked Cubit, or a Section's test needs zero state variants, the
widget is probably misclassified — fix the tier before adding scaffolding to make the test
pass.

## Do / Don't

- DO name files by role: `<feature>_screen.dart`, `<thing>_section.dart`, `<thing>_view.dart`.
- DO keep Views ignorant of Cubit/repository/state — parameters and callbacks only.
- DO promote a View to `vm_storyboard` or a shared package the moment it repeats in a second
  feature — don't wait for a third occurrence.
- DO set `keyboardType`/`textInputAction` on every text input to match its real purpose (email,
  phone, number, search, ...) — never leave the default text keyboard for a specialized field.
- DON'T give a Section its own Cubit "because it's big" — state stays owned by the feature's
  single Cubit; Sections orchestrate, they don't fork state ownership.
- DON'T import across two features' `presentation/` folders directly.
- DON'T classify by line count or visual size — classify by responsibility (see the decision
  order above).

## Checklist

- [ ] Every presentation widget is unambiguously a Screen, Section or View (by
      responsibility, not size).
- [ ] Views take no `Cubit`/`State`/repository — parameters and callbacks only.
- [ ] Sections read this feature's `State`; none are reused or promoted cross-feature.
- [ ] A View repeated in 2+ features has been promoted (`vm_storyboard` or a shared package),
      not duplicated.
- [ ] Every text input sets `keyboardType`/`textInputAction` matching its real purpose; no
      field silently uses the default text keyboard.
- [ ] No direct import between two features' `presentation/` folders.
- [ ] Views have standalone/golden tests; Sections have state-driven widget tests; Screen has
      shallow integration tests.

## References

- `references/structure.md` — the `presentation/<feature>/` folder tree to reproduce.
