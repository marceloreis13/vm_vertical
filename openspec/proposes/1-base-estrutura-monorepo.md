# Propose 1 — Base / Estrutura do Monorepo (vm_core)

## Objetivo

Estabelecer o alicerce ("tabuleiro de Lego") sobre o qual todos os módulos e apps
serão construídos. Este propose **não entrega funcionalidade de negócio**: entrega a
estrutura, as convenções e a tooling que garantem que módulos sejam desacoplados,
standalone e combináveis sob demanda. É pré-requisito de todos os demais proposes.

## Escopo

1. **Estrutura do monorepo**
   ```
   apps/            # aplicativos finais (consomem módulos sob demanda)
   packages/        # módulos reutilizáveis (vm_*)
   openspec/        # artefatos SDD (proposes, specs, design, tasks)
   docs/            # base de contexto viva (ver "Artefatos de contexto")
   ```
2. **Gerenciamento do workspace** — adotar apenas o Pub Workspaces (Dart) para
   orquestrar bootstrap, análise, testes e versionamento entre packages, garantindo
   **uma única fonte de verdade por dependência transitiva** (sem redundância/conflito).
3. **Convenções de arquitetura** — Clean Architecture + Feature-First padronizadas
   (camadas `presentation` / `domain` / `data`), com template de estrutura de pasta
   por módulo e por feature.
4. **DI padronizada** — GetIt + Injectable: convenção de registro por módulo
   (cada módulo expõe uma função de bootstrap/registro que recebe suas configs
   **injetadas** pelo app consumidor). Nada de config hard-coded dentro dos módulos.
5. **Padrão Barrel (Library Export)** — cada package expõe sua API pública por um
   único arquivo barril (`lib/<nome>.dart`). Definir e documentar a regra: só o barril
   é público; `src/` é privado. Esta convenção deve ser registrada no `CLAUDE.md`.
6. **Template de módulo standalone** — scaffold padrão que todo `vm_*` segue,
   incluindo diretório `example/` compilável isoladamente e, quando o módulo exigir
   insumos, **dados mockados** e facilmente manipulados para para permitir o build standalone e experimentações.
7. **Contrato de theming** — o `vm_storyboard` define um conjunto de **tokens padrão**
   (cores e fontes default) expostos via `ThemeExtension`. Os apps que o importam podem
   **(a) sobrescrever** um subconjunto customizável — paleta, fontes e logo próprios — e
   **(b) estender** com tokens adicionais (novas cores/fontes) para uso dos seus próprios
   widgets. O restante dos tokens (espaçamentos, raios, elevações, comportamento dos
   componentes) permanece **fixo**, garantindo a mesma identidade visual entre apps.
   Componentes compartilhados consomem apenas os tokens padrão; tokens estendidos ficam
   no escopo do app que os declarou.
8. **Tooling de qualidade** — lint compartilhado (analysis_options), convenção de
   testes (unit/widget/golden) e scripts comuns (build_runner para Freezed/Injectable).
9. **Artefatos de contexto** — criar a base de documentação viva em `docs/` que
   descreve o que existe, como cada módulo é usado e como injetar suas configs.
   Regra do projeto: **essa base é atualizada a cada novo módulo criado.**

## Critérios de sucesso

- `apps/` e `packages/` existem, com pelo menos um app-esqueleto que compila (quando aplicavel no cado dos packages).
Quando for casos como network ou navigator, criar exemplos com simulações visuais)
- Um novo módulo pode ser criado a partir do template e roda via `example/`.
- Dependências entre módulos são explícitas e sem duplicação nos apps.
- Padrão Barrel e convenções de DI documentados no `CLAUDE.md` e em `docs/`.
- `docs/` contém o índice de contexto inicial, pronto para crescer.

## Fora de escopo

- Implementação dos módulos em si (cada um tem seu propose próprio).
- CI/CD, publicação em stores.

## Stack

Flutter 3.44 · Cubit · go_router · Freezed + JsonSerializable · GetIt + Injectable ·
Testes unit/widget/golden.
