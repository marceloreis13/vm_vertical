## Context

O projeto ainda não tem nenhum módulo `vm_*`; `bootstrap-monorepo` só estabeleceu a estrutura do workspace e as convenções (Clean Architecture + Feature-First, DI via GetIt/Injectable, Barrel, scaffold padrão). `vm_storyboard` é o primeiro módulo real e valida esse scaffold na prática (risco já previsto no design do `bootstrap-monorepo`).

Restrições da stack: Flutter 3.44, Cubit para estado, Freezed para modelos imutáveis, testes unit/widget/golden. O módulo não conhece nenhum app específico — apps injetam o que pode variar.

## Goals / Non-Goals

**Goals:**
- Um único `ThemeExtension` (`VmThemeTokens`) reunindo espaçamentos, raios, elevações, durações de animação e escala tipográfica.
- `ThemeData` claro/escuro derivado dos tokens.
- Contrato de customização por app: paleta de cores e logo são obrigatoriamente injetados pelo app; fonte tem uma família default empacotada no módulo, com override opcional.
- Biblioteca de componentes (Button, Input, SearchField, Card, List item, Avatar/Image, AppBar, Chip, Badge, Snackbar, Banner, Segmented control, loading/empty/error, Dialog) que só consome tokens/tema padrão.
- Direção visual fixa e única (espaçosa, cantos arredondados, elevação por sombra suave, motion fluido, tipografia expressiva — inspirada na Airbnb) aplicada a todos os apps por igual.
- `example/` tipo galeria cobrindo todos os componentes, em uma paleta mock, nos dois temas — base dos golden tests.
- Ícones via Material Icons embutido no Flutter (sem asset customizado).

**Non-Goals:**
- Lógica de negócio, navegação, acesso a dados.
- Asset de logo default empacotado (só o slot/contrato é definido).
- Conjunto de ícones customizado.

> Nota pós-implementação: o non-goal original "múltiplas paletas mock no
> `example/`" foi revisitado e implementado — ver a seção `example/` em
> Decisions.

## Decisions

### Um único `ThemeExtension` (`VmThemeTokens`)
Todos os tokens fixos (spacing, radius, elevation, motion/duration, type scale) ficam em uma classe Freezed `VmThemeTokens extends ThemeExtension<VmThemeTokens>`, acessada via `Theme.of(context).extension<VmThemeTokens>()`.
- **Por quê:** um único ponto de consumo é mais simples para quem constrói componentes; evita registrar múltiplas extensions no `ThemeData`.
- **Alternativa considerada:** uma extension por categoria (`VmSpacing`, `VmRadius`, ...) — rejeitada por verbosidade extra sem ganho relevante neste estágio.

### Paleta e logo são obrigatórios; fonte tem default com override opcional
`VmThemeConfig` (passado pelo app à função de registro do módulo) exige `VmColorPalette` e `VmLogo` (slot: `Widget Function(BuildContext)` ou `ImageProvider`, a decidir na implementação); `fontFamily` é opcional (`String?`), com fallback para a fonte default empacotada no módulo.
- **Por quê:** resolve a contradição do brief entre "fonte fixa" (Escopo) e "fonte sobrescrevível" (Injeção) na direção escolhida pelo usuário: fonte default + override opcional, mantendo paleta e logo sempre exigidos do app (não há "app sem identidade visual própria").
- **Alternativa considerada:** fonte totalmente fixa — rejeitada por decisão explícita do usuário.

### Registro via GetIt, sem Injectable, expondo Config + Tokens + Theme
A função pública de registro é imperativa — `void registerVmStoryboardModule(GetIt getIt, {required VmThemeConfig config})` — e não usa `@module`/codegen do Injectable; ela valida `palette`/`logo` obrigatórios e registra três singletons no GetIt: `VmThemeConfig` (o que foi injetado), `VmThemeTokens` (os tokens fixos) e `VmTheme` (um wrapper Freezed `{ThemeData light, ThemeData dark}`). O app resolve `getIt<VmTheme>()` e passa `.light`/`.dark` para `MaterialApp.theme`/`.darkTheme`; código fora da árvore de widgets (Cubits, casos de uso) pode resolver `VmThemeConfig`/`VmThemeTokens` do GetIt sem precisar de `BuildContext`.
- **Por quê:** segue a convenção de DI já estabelecida em `module-conventions` ("todo módulo expõe um entry point de registro via GetIt + Injectable" — aqui sem geração de código, por ser um caso simples de config→tema, sem múltiplas dependências internas a resolver). O wrapper `VmTheme` evita a colisão de registrar `ThemeData` duas vezes no GetIt (mesmo tipo, claro/escuro), sem depender de `instanceName` (string mágica). Expor `VmThemeConfig`/`VmThemeTokens` também no GetIt (não só via `Theme.of(context)`) evita que lógica de domínio precise de `BuildContext` para ler tokens/paleta.
- **Alternativas consideradas:** instâncias nomeadas no GetIt (`instanceName: 'light'/'dark'`) — rejeitada por depender de strings para desambiguar um tipo; `@module` do Injectable com codegen — rejeitado por cerimônia desnecessária neste primeiro módulo, sem múltiplas dependências internas para orquestrar; registrar só `VmTheme` (sem `VmThemeConfig`/`VmThemeTokens` no GetIt) — rejeitada por limitar o acesso aos tokens/paleta a código dentro da árvore de widgets.

### Fonte default empacotada como asset do módulo
O módulo empacota uma família tipográfica default (ex. via `pubspec.yaml`/`assets/fonts` do próprio `vm_storyboard`), declarada no `flutter.fonts` do package. Nenhuma dependência de serviço externo (ex. `google_fonts` via rede) é usada, para manter o `example/` e os golden tests determinísticos offline.

### Ícones: Material Icons, sem asset customizado
Componentes usam `Icons.*` do Flutter. Nenhum pacote de ícone adicional é introduzido nesta change; se um app precisar de ícone customizado, ele injeta via slot próprio do componente (ex. `leading`/`icon` params), não pelo módulo.

### Logo: apenas o slot, sem asset default
`VmLogo` é um contrato (não uma imagem embutida). Cada app que registra `vm_storyboard` é obrigado a fornecer seu logo; se não fornecer, a função de registro falha de forma explícita (erro de configuração) em vez de renderizar um placeholder silencioso.
- **Por quê:** decisão explícita do usuário — evita builds "esquecendo" o logo e não descobrindo até QA visual.

### Componentes no escopo desta change
Button, Input/TextField, SearchField, Card, List item, Avatar/Image, AppBar, Chip, Badge, Snackbar, Banner, Segmented control, estados de loading/empty/error, Dialog. Lista ampliada em relação à do brief original (que listava só Button/Input/Card/List item/AppBar/estados/Dialog) depois de cruzar com as telas já previstas nos briefs 15 (`app_weather`) e 16 (`app_news`): busca de cidade/artigo (SearchField), filtro por fonte/tipo (Chip), confirmação de ação (Snackbar), banner offline (Banner), indicador de notificação (Badge), imagem de artigo/ícone de clima (Avatar/Image), alternância de unidade °C/°F (Segmented control). Cada um é uma feature-first slice dentro de `lib/src/presentation/` (ex. `presentation/button/`, `presentation/input/`, ...), consumindo só `VmThemeTokens` e `Theme.of(context)`.
- **Alternativa considerada:** manter só a lista original do brief e adiar o restante — rejeitada porque os dois apps futuros já declaram a necessidade desses elementos; mais barato incluir agora do que abrir uma change de expansão depois.

### Direção visual dos tokens fixos (inspirada na Airbnb)
Os valores default de `VmThemeTokens` seguem uma linguagem visual espaçosa, com cantos arredondados, elevação por sombra suave e movimento fluido, inspirados no padrão de UI da Airbnb (referência trazida pelo usuário para "limpeza visual, animação e fluidez de informação"). Concretamente:
- **Spacing**: escala generosa, com mais respiro entre elementos do que a densidade "compacta" padrão do Material.
- **Radius**: cantos bem arredondados em componentes de superfície (cards, botões, inputs, dialogs, banners) — na faixa de 12–16px para elementos grandes, menor para elementos pequenos (chips/badges).
- **Elevation**: sombra difusa e sutil (Material 3 soft), sem efeito de vidro/blur.
- **Motion**: durações mais longas (250–350ms) com curvas suaves (`Curves.easeInOutCubic`/emphasized), priorizando fluidez sobre velocidade.
- **Typography**: hierarquia expressiva — títulos grandes e com peso forte, boa distinção entre níveis (display/headline/title/body).

Esses valores são o **default fixo da plataforma para todos os apps**; não fazem parte do subconjunto customizável (ver requirement "Tokens are fixed across apps" em `design-tokens`). Uma identidade visual mais específica por app — por exemplo, o estilo náutico/"Liquid Glass" de referência para o `app_weather` (inspirado no Tide Guide) — é obtida **somente** por paleta de cores, logo e imagens/ícones de conteúdo do próprio app, nunca por override de elevação, raio ou movimento. Essa direção específica do `app_weather` será tratada no change do brief 15, não aqui.
- **Por quê:** decisão explícita do usuário — Airbnb como referência de baseline de todo o sistema; mantém intacto o contrato "mesma identidade visual entre apps" do brief 2, sem abrir uma nova dimensão de customização por app.
- **Alternativa considerada:** ampliar o subconjunto customizável para incluir elevação/raio/movimento (permitindo glassmorphism por app) — rejeitada agora para preservar a consistência entre apps; pode ser revisitada como uma change própria se um caso real exigir.

### `example/`: uma paleta mock nos golden tests, múltiplas paletas na demo
A `GalleryScreen` (o baseline testado via golden) renderiza todos os componentes com uma `VmColorPalette` mock fixa (`VmColorPalette.mock()`), alternando claro/escuro. Os golden tests capturam essa galeria nos dois temas — isso não mudou.
- **Por quê:** decisão do usuário — cobertura suficiente para provar o contrato de theming sem multiplicar a matriz de goldens antes de haver um segundo app real consumindo o módulo.

Adicionalmente, o *app shell* do `example/` (`VmStoryboardGalleryApp`, fora da `GalleryScreen` testada) ganhou um `DropdownMenu` com 3 paletas mock (Sunset/Ocean/Forest — `example/lib/mock_palettes.dart`) que reconstrói o `VmTheme` via `buildVmTheme(tokens: getIt<VmThemeTokens>(), palette: ..., fontFamily: ...)` a cada seleção.
- **Por quê:** pedido explícito do usuário — o `example/` deve mostrar, no código, como trocar a paleta em runtime usando o módulo, sem exigir novo registro no GetIt.
- **Por que fora da `GalleryScreen`:** só um widget acima do `MaterialApp` pode reconstruir `theme`/`darkTheme`; a `GalleryScreen` continua agnóstica de paletas e permanece o baseline de golden com paleta única — o seletor é puramente uma demonstração de DX no app shell, não um requisito testado do módulo.

### Galeria organizada por Screen/Sections/Views, com Cubit
Depois da implementação inicial (tasks 1–8), o Harness ganhou a convenção `vm-ui-composition` (Screen/Sections/Views por responsabilidade, nunca por tamanho). A galeria — que tinha nascido como uma `GalleryPage` única com `StatefulWidget`/`setState` — foi refeita para segui-la:
- `GalleryCubit`/`GalleryState` (Freezed) substituem o `setState` ad-hoc — o próprio exemplo canônico do módulo estava contrariando a convenção de Cubit do projeto.
- `GalleryScreen` (entry point, com `TabBar`/`TabBarView` de 4 tabs: Actions/Inputs/Surfaces/Feedback) e as `Sections` (`ActionsSection`, `InputsSection`, `SurfacesSection`, `FeedbackSection`) passaram a viver dentro do próprio `vm_storyboard` (`lib/src/presentation/gallery/`), não em `example/`.
- **Por quê:** manter `GalleryScreen` no pacote (exportado no barril) elimina a duplicação que existia entre `example/` e o golden test (antes havia uma `_GalleryScreen` particular só para o teste, reimplementando a composição). Organizar por tabs também é mais fiel à redação original do requirement "Gallery is the golden test baseline" (que já falava em "gallery's *screens*", no plural) do que uma tela única com scroll infinito.
- **Alternativa considerada:** manter a tela única, só com divisórias visuais mais claras — rejeitada por não resolver o problema de escala conforme o catálogo de componentes cresce.

### `VmAppBar` ganhou suporte a `bottom`
Para acomodar a `TabBar` da galeria, `VmAppBar` passou a aceitar um `bottom: PreferredSizeWidget?` opcional (com `preferredSize` ajustado). É um ganho de API legítimo do componente, não específico da galeria — qualquer tela com abas pode usá-lo.

### Teclado deve seguir o propósito do campo
Descoberto tardiamente (o campo de email da galeria não trocava de teclado): `VmTextField` (genérico) ganhou `keyboardType`/`textInputAction` como parâmetros abertos; `VmSearchField` (propósito fixo) passou a cravar `TextInputType.text` + `TextInputAction.search` internamente, sem exigir que quem chama repita essa decisão. A regra virou convenção permanente do Harness (skill `vm-ui-composition`, seção "Input fields must declare the right keyboard"), não só um fix pontual — ver requirement correspondente em `component-library`.

## Risks / Trade-offs

- [Primeira validação prática do scaffold `bootstrap-monorepo`] → Se o scaffold documentado não encaixar bem na prática, atualizar `docs/module-scaffold.md` como parte desta change.
- [Fonte empacotada aumenta o tamanho do módulo] → Usar uma única família (poucos pesos) como default; apps que quiserem outra fonte fazem override.
- [Registro falhando sem logo pode surpreender quem só quer prototipar] → Documentar claramente em `docs/index.md` que paleta e logo são obrigatórios ao registrar o módulo.
- [Uma paleta mock só pode esconder bugs de contraste em paletas reais] → Aceito como trade-off nesta primeira versão; golden tests futuros por app real cobrem isso.
