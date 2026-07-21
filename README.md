# vm_core

> A modular project focused on decoupling, code and context reuse, and fast delivery.

vm_core is a Flutter foundation built like a box of Lego. Instead of starting every app from zero, you assemble it from independent modules that are already built, tested and documented. The goal is simple: spend time only on what does not exist yet, and reuse everything else.

It is being built in public, spec-first, using SDD (Spec-Driven Development) with OpenSpec and Claude. If you got here from my LinkedIn series, this is the project behind the posts.

## The idea

- **Decoupling.** Each module knows nothing about the app that uses it. Everything it needs (keys, endpoints, config) is injected at call time.
- **Reuse of code and context.** The Lego pieces are reused across apps, and so is the documentation. Every module carries the context needed to reuse it, so the next project starts faster.
- **Agility.** New app equals combining existing pieces. Missing a piece? You build one more reusable piece, not a one-off.
- **Standalone modules.** Whenever possible each module compiles on its own through an `example/`, with mocked data when needed. Easy to see, easy to maintain.

## Built spec-first

Nothing starts as code. Every piece starts as a written brief in [`briefs/`](briefs), which feeds the OpenSpec flow (proposal, spec, design, tasks). Each change is reviewed and approved before implementation, and decisions are documented at the same pace as the development, so the docs stay alive as reusable context.

## Structure

```
apps/         # final apps, assembled from modules on demand
packages/     # reusable modules (vm_*)
briefs/       # numbered module briefs, in build order (input to the SDD flow)
openspec/     # OpenSpec artifacts: specs (source of truth) + changes
docs/         # living context that grows with each module
```

Planned modules include a shared design system (`vm_storyboard`), networking, local storage, navigation, localization, analytics, logging, auth, config, ads, tabs, notifications and connectivity. See the briefs for the full list and the order they get built.

## Proof of the model

Two example apps assembled from the same pieces, changing only palette and logo:

- **Weather app** using the design system defaults, no auth. Open API, no key.
- **News app** overriding the theme with its own identity, plus optional login. Open API.

Same components, two identities, most of the code shared. That is the whole point.

## Status

Early. The foundation is being specced and built module by module. Follow along to watch it grow.

## Follow the journey

I post each milestone on LinkedIn, in Portuguese and English: [linkedin.com/in/marceloreis13](https://linkedin.com/in/marceloreis13).

## Stack

Flutter 3.44, Clean Architecture (feature-first), Cubit, go_router, Freezed and JsonSerializable, GetIt and Injectable. Unit, widget and golden tests.

---

## 🇧🇷 Em português

**Um projeto modular, focado em desacoplamento, reuso de código e contexto, e agilidade na entrega.**

vm_core é uma base em Flutter montada como uma caixa de Lego. Em vez de começar cada app do zero, você o monta a partir de módulos independentes já prontos, testados e documentados. A meta é gastar tempo só com o que ainda não existe e reaproveitar todo o resto.

O projeto está sendo construído em público, spec-first, com SDD (OpenSpec + Claude). Se você chegou pela minha série no LinkedIn, é este o projeto por trás dos posts.

Princípios: módulos desacoplados (toda configuração é injetada), reuso de código e de contexto (a documentação viaja junto com cada peça), e agilidade (app novo é encaixar peças; faltou uma, você cria mais uma reutilizável). Cada módulo, quando possível, roda sozinho pelo `example/`, com dados mockados quando preciso.

Acompanhe a jornada: [linkedin.com/in/marceloreis13](https://linkedin.com/in/marceloreis13).
