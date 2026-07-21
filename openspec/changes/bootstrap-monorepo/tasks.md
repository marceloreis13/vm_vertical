## 1. Workspace

- [ ] 1.1 Configurar o `pubspec.yaml` da raiz como Pub Workspace (`resolution: workspace` + `workspace:` listando os membros)
- [ ] 1.2 Criar os diretórios `apps/`, `packages/` e `docs/` (`openspec/` já existe)
- [ ] 1.3 Rodar `dart pub get` na raiz e confirmar resolução única (um único `pubspec.lock`, sem duplicidade)

## 2. Tooling e lint compartilhados

- [ ] 2.1 Criar `analysis_options.yaml` compartilhado na raiz com lints estritos
- [ ] 2.2 Habilitar a regra que bloqueia import de `src/` de fora do package (padrão Barrel)
- [ ] 2.3 Padronizar `build_runner` (Freezed / JsonSerializable / Injectable) como dev deps do scaffold

## 3. Convenções documentadas (em `docs/`)

- [ ] 3.1 Documentar a estrutura Clean Architecture + Feature-First por módulo e por feature
- [ ] 3.2 Documentar a convenção de DI (GetIt + Injectable): função de registro que recebe config injetada, nada hard-coded
- [ ] 3.3 Documentar o padrão Barrel (só o barril é público; `src/` privado) e registrar a convenção no `CLAUDE.md`
- [ ] 3.4 Documentar o scaffold padrão de módulo standalone (barril, `src/` em camadas, `example/` com mocks manipuláveis, `test/` com unit/widget/golden), incluindo a orientação de `example/` com simulações visuais para módulos de infraestrutura (ex.: network, navigation)

## 4. Base de docs viva

- [ ] 4.1 Criar `docs/index.md` com o mapa inicial (módulos, uso e injeção de config)
- [ ] 4.2 Registrar a regra "atualizar `docs/` a cada módulo novo" e adicionar os ponteiros das convenções (Barrel, DI) no `CLAUDE.md`

## 5. Validação

- [ ] 5.1 Confirmar que `apps/` e `packages/` existem e que o workspace resolve dependências sem duplicação
- [ ] 5.2 Confirmar que o lint bloqueia import de `src/` externo
- [ ] 5.3 Confirmar que `docs/` contém o índice de contexto inicial e as convenções (Barrel, DI) documentadas no `CLAUDE.md` e em `docs/`
