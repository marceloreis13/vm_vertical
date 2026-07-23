## 1. Workspace

- [x] 1.1 Configurar o `pubspec.yaml` da raiz como Pub Workspace (`resolution: workspace` + `workspace:` listando os membros)
- [x] 1.2 Criar os diretórios `apps/`, `packages/` e `docs/` (`openspec/` já existe)
- [x] 1.3 Rodar `dart pub get` na raiz e confirmar resolução única (um único `pubspec.lock`, sem duplicidade)

## 2. Tooling e lint compartilhados

- [x] 2.1 Criar `analysis_options.yaml` compartilhado na raiz com lints estritos
- [x] 2.2 Habilitar a regra que bloqueia import de `src/` de fora do package (padrão Barrel)
- [x] 2.3 Padronizar `build_runner` (Freezed / JsonSerializable / Injectable) como dev deps do scaffold

## 3. Convenções documentadas (em `docs/`)

- [x] 3.1 Documentar a estrutura Clean Architecture + Feature-First por módulo e por feature
- [x] 3.2 Documentar a convenção de DI (GetIt + Injectable): função de registro que recebe config injetada, nada hard-coded
- [x] 3.3 Documentar o padrão Barrel (só o barril é público; `src/` privado) e registrar a convenção no `CLAUDE.md`
- [x] 3.4 Documentar o scaffold padrão de módulo standalone (barril, `src/` em camadas, `example/` com mocks manipuláveis, `test/` com unit/widget/golden), incluindo a orientação de `example/` com simulações visuais para módulos de infraestrutura (ex.: network, navigation)

## 4. Base de docs viva

- [x] 4.1 Criar `docs/index.md` com o mapa inicial (módulos, uso e injeção de config)
- [x] 4.2 Registrar a regra "atualizar `docs/` a cada módulo novo" e adicionar os ponteiros das convenções (Barrel, DI) no `CLAUDE.md`

## 5. Validação

- [x] 5.1 Confirmar que `apps/` e `packages/` existem e que o workspace resolve dependências sem duplicação
- [x] 5.2 Confirmar que o lint bloqueia import de `src/` externo
- [x] 5.3 Confirmar que `docs/` contém o índice de contexto inicial e as convenções (Barrel, DI) documentadas no `CLAUDE.md` e em `docs/`
