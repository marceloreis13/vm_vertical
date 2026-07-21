## Context

O projeto é hoje um scaffold Flutter único (`lib/main.dart`). O objetivo é transformá-lo no alicerce de uma plataforma modular onde apps são montados a partir de módulos reutilizáveis (`packages/vm_*`). Este change estabelece estrutura, convenções e tooling; não implementa nenhum módulo de negócio (changes 2 a 16), mas define os contratos que todos eles seguirão.

Restrições (stack do brief): Flutter 3.44; Clean Architecture + Feature-First; Cubit; go_router; Freezed + JsonSerializable; GetIt + Injectable; testes unit/widget/golden.

## Goals / Non-Goals

**Goals:**
- Estrutura de monorepo (`apps/`, `packages/`, `openspec/`, `docs/`) com fonte única de dependências.
- Convenções obrigatórias e verificáveis: camadas, DI injetada, padrão Barrel.
- Convenção documentada do template de módulo standalone (`example/` compilável, mocks manipuláveis).
- Tooling de qualidade: lint compartilhado, testes unit/widget/golden, build_runner.
- Base de docs viva que cresce a cada módulo.

**Non-Goals:**
- Implementar qualquer módulo de negócio (changes 2 a 16).
- **Contrato de theming** — tratado no change do `vm_storyboard`.
- CI/CD, publicação em stores.

## Decisions

### Pub Workspaces (não Melos)
Usar o suporte nativo de workspaces do Dart (`resolution: workspace` na raiz + `workspace:` listando os membros). Um único `pubspec.lock` na raiz garante fonte única por dependência transitiva, e orquestra bootstrap, análise, testes e versionamento entre packages.
- **Por quê:** menos tooling externo, resolução nativa, uma fonte de verdade.
- **Alternativa considerada:** Melos (scripts de orquestração), rejeitada por adicionar dependência e cerimônia; pode ser somado depois se a orquestração exigir.

### Layout de package (convenção documentada)
```
packages/vm_x/
  lib/vm_x.dart        # barril público (único ponto de import)
  lib/src/             # privado; presentation / domain / data (feature-first)
  example/             # app runnable standalone (+ mocks manipuláveis)
  test/                # unit / widget / golden
  pubspec.yaml
```
- **Por quê:** separa API pública (barril) de implementação (`src/`), viabiliza o padrão Barrel e o build standalone.

### Template como convenção documentada (não package físico)
O scaffold é definido e documentado em `docs/`, servindo de referência para todo `vm_*`. Não se cria um package físico de template neste change.
- **Por quê:** começar leve; a validação prática do scaffold acontece com o primeiro módulo real (change 2). Um package de referência ou gerador pode ser adicionado depois.

### DI por injeção explícita
Cada módulo expõe uma função de registro (GetIt + Injectable) que recebe a config do app. Nada de config global ou hard-coded no módulo.
- **Por quê:** é o que garante desacoplamento real e reuso entre apps.
- **Alternativa considerada:** singletons/config global no módulo, rejeitada por acoplar o módulo ao ambiente.

### Padrão Barrel reforçado por lint
Somente `lib/vm_x.dart` é público; imports a `src/` de fora são proibidos e sinalizados pelo lint compartilhado. A convenção é documentada em `docs/` e no `CLAUDE.md`.

### Docs vivas em `docs/`
`docs/index.md` mapeia módulos, uso e injeção de config; regra de atualização a cada módulo novo.
- **Por quê:** contexto acumulado reduz retrabalho e custo.

## Risks / Trade-offs

- [Pub Workspaces é relativamente novo e menos "batteries-included" que Melos] → Manter scripts simples via `dart`/`flutter`; reavaliar Melos só se a orquestração exigir.
- [Convenções sem enforcement viram letra morta] → Lint estrito no `analysis_options` compartilhado.
- [Template só documentado pode divergir na prática] → Validar o scaffold com o primeiro módulo real (change 2) e ajustar a doc se necessário.
- [`example/` standalone pode acoplar a mocks frágeis] → Padronizar mocks manipuláveis na convenção do scaffold.
