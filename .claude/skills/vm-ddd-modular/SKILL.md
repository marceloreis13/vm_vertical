---
name: vm-ddd-modular
description: Use when modeling a domain or defining module boundaries in this project — establishing ubiquitous language, distinguishing entities from value objects, designing aggregates and their invariants, repositories per aggregate root, domain services, and deciding what belongs inside a vm_* module versus the app. Apply when starting a module or shaping its domain.
metadata:
  author: vm_core
  version: "1.0"
---

# DDD & modularization (vm_core)

How to model the domain and draw module boundaries in the Lego platform. Pair with
`vm-clean-architecture` (how the layers are structured) and `vm-dart-idioms` (how to write it).
See `references/modeling.dart` for a worked example.

## A module is a bounded context

- Each `vm_*` module owns one **bounded capability** with its own ubiquitous language.
  The same word can mean different things in different modules; do not share a "god model".
- What lives **in the module**: its domain, its data access, its presentation, and a DI
  registration that receives config injected by the app.
- What lives **in the app**: composition (which modules, which config), and app-specific
  features that combine modules.
- Modules talk through their **public API (barrel)** and through injected abstractions,
  never by reaching into each other's `src/`.

## Ubiquitous language

- Name types, methods and files after the domain terms the feature actually uses. The code
  should read like the domain, not like the framework.
- If a term is ambiguous, resolve it in the brief before coding (this is exactly what the
  brief → questions step is for).

## Entities vs value objects

- **Entity**: has identity that persists across changes (`Article` with an `ArticleId`).
  Two entities with the same id are the same thing.
- **Value object**: no identity; equality by value; immutable; validates itself on creation
  (`Money`, `EmailAddress`, `ArticleId`). Prefer value objects over primitives to make
  illegal states unrepresentable.

## Aggregates and invariants

- An **aggregate** is a cluster of entities/value objects with one **root**. Outside code
  references only the root.
- The root **enforces the invariants** of the whole aggregate. Mutations go through the root,
  producing a new immutable instance (no setters).
- Keep aggregates small. If two things can change independently, they are probably two
  aggregates.

## Repositories and services

- One **repository per aggregate root**, declared as an interface in `domain`, returning
  `Result<T>`. It hides persistence; the domain never knows about JSON, HTTP or DB.
- Put logic that spans multiple aggregates (and has no natural home on one) in a **domain
  service** — pure, in `domain`.

## Boundaries and anti-corruption

- The `data` layer is the **anti-corruption layer**: external shapes (models/DTOs) are
  translated to the domain via mappers. No external shape leaks into `domain`/`presentation`.
- When one module consumes another, depend on the other module's public abstraction, and map
  its types at your boundary if they don't fit your language.

## Do / Don't

- DO wrap primitives in value objects that validate themselves.
- DO route all changes to an aggregate through its root, returning a new instance.
- DO keep the domain pure (no Flutter, no IO, no framework).
- DO define one repository per aggregate root.
- DON'T share a single cross-module "entity" between bounded contexts.
- DON'T expose internal entities of an aggregate for external mutation.
- DON'T let persistence/serialization concerns shape the domain model.

## Checklist

- [ ] The module is one bounded capability with its own ubiquitous language.
- [ ] Primitives that carry rules are value objects that validate on creation.
- [ ] Each aggregate has a clear root that enforces its invariants; mutations return new instances.
- [ ] One repository interface per aggregate root, in `domain`, returning `Result<T>`.
- [ ] External types are mapped at the `data` boundary; nothing external leaks inward.
- [ ] Cross-module use goes through public barrels and injected abstractions only.

## References

- `references/modeling.dart` — a small aggregate (root + value objects + invariant + repository).
