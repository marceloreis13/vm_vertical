## Why

A base modular ("caixa de Lego") precisa de um alicerce antes de qualquer módulo existir. Este change não entrega funcionalidade de negócio: entrega a estrutura, as convenções e a tooling que garantem que módulos sejam desacoplados, standalone e combináveis sob demanda. É pré-requisito de todos os módulos e apps seguintes (briefs 2 a 16).

## What Changes

- Estrutura do monorepo (`apps/`, `packages/`, `openspec/`, `docs/`) gerenciada por **Pub Workspaces**, com **uma única fonte de verdade por dependência transitiva** (sem redundância/conflito).
- Convenções de **Clean Architecture + Feature-First** (camadas `presentation`/`domain`/`data`), com estrutura de pasta por módulo e por feature.
- Convenção de **DI** (GetIt + Injectable): cada módulo expõe uma função de registro que recebe suas configs **injetadas** pelo app consumidor. Nada de config hard-coded dentro dos módulos.
- **Padrão Barrel**: cada package expõe sua API pública por um único barril `lib/<nome>.dart`; só o barril é público, `src/` é privado. A convenção é registrada no `CLAUDE.md`.
- **Template de módulo standalone** (convenção documentada): scaffold que todo `vm_*` segue, com `example/` compilável isoladamente e, quando o módulo exigir insumos, dados mockados e facilmente manipuláveis para permitir o build standalone e experimentações.
- **Tooling de qualidade**: lint compartilhado (`analysis_options`), convenção de testes (unit/widget/golden) e `build_runner` (Freezed/JsonSerializable/Injectable).
- **Base de documentação viva** em `docs/`, descrevendo o que existe, como cada módulo é usado e como injetar suas configs, atualizada a cada módulo novo.

## Capabilities

### New Capabilities
- `monorepo-workspace`: estrutura do repositório e gerenciamento de dependências via Pub Workspaces, com fonte única por dependência transitiva.
- `module-conventions`: camadas Clean Architecture/Feature-First, convenção de DI (GetIt + Injectable), padrão Barrel e tooling de qualidade (lint compartilhado, build_runner) obrigatórios para todo módulo.
- `module-template`: convenção documentada do scaffold de módulo standalone (barril, `src/` em camadas, `example/` com mocks manipuláveis, `test/` com unit/widget/golden).
- `project-context-docs`: base de documentação viva em `docs/` e a regra de atualização a cada módulo.

### Modified Capabilities
<!-- Nenhuma. openspec/specs/ está vazio; este é o primeiro change do projeto. -->

## Impact

- Cria a raiz do workspace (`pubspec.yaml` com `workspace:`), e as pastas `apps/`, `packages/`, `docs/` (`openspec/` já existe).
- Adiciona `analysis_options.yaml` compartilhado e a configuração de `build_runner`.
- Estabelece as convenções referenciadas por todos os changes seguintes (2 a 16).
- Sem impacto em código de produção existente (o projeto ainda é o scaffold Flutter inicial).
- **Fora de escopo:** implementação dos módulos (cada um tem seu change); o **contrato de theming** (tratado no change do `vm_storyboard`); CI/CD e publicação em stores.
