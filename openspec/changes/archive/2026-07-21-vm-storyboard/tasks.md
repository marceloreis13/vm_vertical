## 1. Package scaffold

- [x] 1.1 Criar `packages/vm_storyboard/` seguindo o scaffold padrão (`lib/vm_storyboard.dart`, `lib/src/{presentation,domain,data}`, `example/`, `test/{unit,widget,golden}`)
- [x] 1.2 Configurar `pubspec.yaml` do package (`resolution: workspace`) e registrar `packages/vm_storyboard` no `workspace:` da raiz
- [x] 1.3 Adicionar `analysis_options.yaml` do package incluindo o compartilhado (`include: ../../analysis_options.yaml`)
- [x] 1.4 Adicionar dev deps de code gen (`build_runner`, `freezed`, `json_serializable`) conforme convenção documentada

## 2. Design tokens

- [x] 2.1 Modelar `VmThemeTokens` (Freezed) como `ThemeExtension<VmThemeTokens>`: spacing, radius, elevation, animation duration, escala tipográfica
- [x] 2.2 Definir valores default dos tokens fixos seguindo a direção visual do `design.md` (inspirada na Airbnb): spacing espaçoso, radius arredondado (~12-16px em superfícies grandes, menor em chips/badges), elevação por sombra suave (sem blur/glassmorphism), motion fluido (250-350ms, curva `easeInOutCubic`/emphasized), tipografia com hierarquia expressiva
- [x] 2.3 Expor `VmThemeTokens` no barril

## 3. Theming

- [x] 3.1 Modelar `VmColorPalette` (Freezed): cores exigidas para derivar o `ColorScheme` claro/escuro
- [x] 3.2 Modelar `VmLogo` como contrato de slot (sem asset default)
- [x] 3.3 Modelar `VmThemeConfig` (Freezed): `palette` obrigatório, `logo` obrigatório, `fontFamily` opcional
- [x] 3.4 Empacotar a fonte default (assets do package + declaração em `pubspec.yaml`/`flutter.fonts`)
- [x] 3.5 Modelar `VmTheme` (Freezed): wrapper `{ThemeData light, ThemeData dark}`
- [x] 3.6 Implementar a função que deriva `VmTheme` (light/dark) a partir de `VmThemeTokens` + `VmThemeConfig`, aplicando `fontFamily` (default ou override)
- [x] 3.7 Implementar `void registerVmStoryboardModule(GetIt getIt, {required VmThemeConfig config})`: valida `palette`/`logo` obrigatórios (erro explícito se ausentes), registra `VmThemeConfig`, `VmThemeTokens` e `VmTheme` como singletons no GetIt, e permite ao app anexar `ThemeExtension`s próprias
- [x] 3.8 Expor `VmThemeConfig`, `VmColorPalette`, `VmLogo`, `VmTheme` e `registerVmStoryboardModule` no barril

## 4. Biblioteca de componentes

- [x] 4.1 Implementar `VmButton` consumindo tokens/tema padrão
- [x] 4.2 Implementar `VmTextField` (input)
- [x] 4.3 Implementar `VmSearchField`
- [x] 4.4 Implementar `VmCard`
- [x] 4.5 Implementar `VmListItem`
- [x] 4.6 Implementar `VmAvatar` (imagem com loading/fallback)
- [x] 4.7 Implementar `VmAppBar`
- [x] 4.8 Implementar `VmChip`
- [x] 4.9 Implementar `VmBadge`
- [x] 4.10 Implementar `VmSnackbar`
- [x] 4.11 Implementar `VmBanner`
- [x] 4.12 Implementar `VmSegmentedControl`
- [x] 4.13 Implementar estados `VmLoadingView`, `VmEmptyView`, `VmErrorView`
- [x] 4.14 Implementar `VmDialog`
- [x] 4.15 Garantir que nenhum componente usa cor/spacing/radius/fonte hard-coded (só tokens/tema) e que ícones usam apenas `Icons.*`
- [x] 4.16 Expor todos os componentes no barril

## 5. Example (galeria/catálogo)

- [x] 5.1 Criar app standalone em `example/` com uma `VmColorPalette` mock e um `VmLogo` mock
- [x] 5.2 Renderizar todos os componentes da biblioteca na galeria, organizados por seção
- [x] 5.3 Adicionar toggle de tema (claro/escuro) na galeria

## 6. Testes

- [x] 6.1 Testes unit dos tokens/tema (derivação de `VmTheme`, validação de `palette`/`logo` obrigatórios, fallback de `fontFamily`, registro correto de `VmThemeConfig`/`VmThemeTokens`/`VmTheme` no GetIt)
- [x] 6.2 Testes widget dos estados loading/empty/error
- [x] 6.3 Golden tests da galeria (todos os componentes) nos temas claro e escuro com a paleta mock
- [x] 6.4 Testes widget de interação dos componentes novos (seleção de chip, seleção de segmented control, auto-dismiss de snackbar, dismiss de banner)

## 7. Documentação viva

- [x] 7.1 Atualizar `docs/index.md` com a entrada de `vm_storyboard` (uso, tokens, como injetar palette/logo/fontFamily)
- [x] 7.2 Se o scaffold padrão precisar de ajuste na prática, atualizar `docs/module-scaffold.md`

## 8. Validação

- [x] 8.1 Confirmar que `example/` compila e roda standalone cobrindo todos os componentes
- [x] 8.2 Confirmar que trocar `palette`/`logo`/`fontFamily` produz um tema visualmente distinto sem alterar nenhum componente
- [x] 8.3 Confirmar que registrar o módulo sem `logo` falha com erro explícito
- [x] 8.4 Rodar `flutter analyze` e a suíte de testes (unit/widget/golden) do package sem falhas

## 9. Pós-implementação (alinhamento com o Harness `vm-ui-composition`)

- [x] 9.1 Substituir o `StatefulWidget`/`setState` da galeria por `GalleryCubit`/`GalleryState` (Freezed), alinhado à convenção de Cubit do projeto
- [x] 9.2 Mover `GalleryScreen`/Sections para dentro do próprio pacote (`lib/src/presentation/gallery/`), eliminando a duplicação de composição que existia entre `example/` e o golden test
- [x] 9.3 Reorganizar a galeria em tabs (Actions/Inputs/Surfaces/Feedback) em vez de uma tela única com scroll, seguindo Screen/Sections/Views
- [x] 9.4 Adicionar `VmAppBar.bottom` (suporte a `TabBar`)
- [x] 9.5 Adicionar `keyboardType`/`textInputAction` em `VmTextField` (parâmetros abertos) e cravar `TextInputType.text`/`TextInputAction.search` em `VmSearchField`
- [x] 9.6 Adicionar seletor de paleta (`DropdownMenu`) no app shell do `example/`, demonstrando `buildVmTheme` com paletas diferentes em runtime
- [x] 9.7 Reescrever os testes afetados (golden por tab/tema, teste de Section com `GalleryCubit` real, teste de Screen para `extraActions`/troca de tab) e regenerar os goldens
- [x] 9.8 Rodar `flutter analyze` e a suíte de testes completa novamente sem falhas
