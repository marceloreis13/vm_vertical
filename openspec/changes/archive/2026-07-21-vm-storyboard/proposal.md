## Why

Todo app da plataforma precisa da mesma identidade visual, variando só paleta e logo. Sem um módulo central de design system, cada app reimplementaria tema e componentes, quebrando a consistência visual e duplicando esforço. `vm_storyboard` é a peça de Lego visual da qual quase todos os outros módulos de UI dependem — é pré-requisito para qualquer feature com interface.

## What Changes

- Novo package `packages/vm_storyboard` seguindo o scaffold padrão (barril, `src/` em camadas, `example/`, `test/`) definido no change `bootstrap-monorepo`.
- **Design tokens** fixos: espaçamentos, raios, elevações, durações de animação, escala tipográfica — expostos como uma única `ThemeExtension` (`VmThemeTokens`).
- **Tema** claro/escuro (`ThemeData`) derivado dos tokens. Paleta de cores e logo são customizáveis por app via injeção; fonte tem uma família default empacotada no módulo, com override opcional pelo app. Espaçamentos, raios, elevações e comportamento dos componentes permanecem fixos.
- **Biblioteca de componentes**: Button, Input/TextField, SearchField, Card, List item, Avatar/Image, AppBar, Chip, Badge, Snackbar, Banner, Segmented control, estados de loading/empty/error, Dialog — consumindo apenas os tokens/tema padrão, sem conhecer nenhum app específico. Lista ampliada em relação ao brief original para cobrir os elementos concretos exigidos pelas telas já previstas do `app_weather` e `app_news` (busca, filtro, confirmação de ação, banner offline, imagem/ícone, alternância de unidade).
- **Direção visual dos tokens fixos**: os valores default (spacing, radius, elevação, motion, tipografia) seguem uma linguagem visual espaçosa, com cantos arredondados, elevação por sombra suave (sem glassmorphism/blur), movimento fluido e tipografia com hierarquia expressiva, inspirada no padrão de UI da Airbnb. É o **único** default fixo da plataforma — não é customizável por app.
- **Ícones**: usa o conjunto Material Icons já embutido no Flutter; nenhum asset de ícone customizado é empacotado nesta change.
- **Logo**: o módulo expõe apenas o slot/contrato (parâmetro ou `ThemeExtension`) para o app injetar seu logo; nenhum asset de logo default é empacotado.
- **`example/`**: app "galeria/catálogo" que renderiza todos os componentes nos temas claro e escuro com uma paleta mock, servindo de storybook visual e base dos golden tests. A galeria (`GalleryScreen`) vive dentro do próprio pacote, organizada em abas por categoria (Actions/Inputs/Surfaces/Feedback), seguindo a convenção `vm-ui-composition` (Screen/Sections/Views) do Harness; o app shell do `example/` ainda demonstra a troca de paleta em runtime via um seletor, para deixar claro no código como um app customiza o tema sem tocar em nenhum componente.

## Capabilities

### New Capabilities
- `design-tokens`: definição e exposição dos tokens de design (cores, tipografia, espaçamentos, raios, elevações, durações) via `ThemeExtension`.
- `theming`: derivação de `ThemeData` claro/escuro a partir dos tokens, e o contrato de customização por app (paleta, logo, fonte opcional) vs. o que permanece fixo.
- `component-library`: biblioteca de widgets reutilizáveis (botões, inputs, search field, cards, listas, avatar/imagem, app bars, chips, badges, snackbars, banners, segmented control, dialogs, estados de loading/empty/error) que consomem apenas tokens/tema padrão.
- `storyboard-example`: app `example/` tipo galeria que cobre todos os componentes e ambos os temas, servindo de base para golden tests.

### Modified Capabilities
<!-- Nenhuma. Este change não altera requisitos das specs existentes (monorepo-workspace, module-conventions, module-template, project-context-docs); apenas as aplica na criação de vm_storyboard. -->

## Impact

- Cria `packages/vm_storyboard/` (barril `lib/vm_storyboard.dart`, `lib/src/{presentation,domain,data}`, `example/`, `test/{unit,widget,golden}`), registrado no `workspace:` da raiz.
- Adiciona dependências de fonte (pacote de fonte empacotado, ex. via `flutter_gen`/assets locais — decidido em design.md) e mantém uso de Material Icons, sem novas dependências de ícone.
- Atualiza `docs/index.md` com a entrada do módulo `vm_storyboard` (uso, tokens, como injetar paleta/logo/fonte), por força da regra "atualizar docs a cada módulo novo".
- Sem impacto em `apps/` existentes (nenhum app consome o módulo ainda).
- **Fora de escopo:** lógica de negócio, navegação, dados; asset de logo default; ícones customizados.
