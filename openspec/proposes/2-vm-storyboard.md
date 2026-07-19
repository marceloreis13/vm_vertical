# Propose 2 — vm_storyboard (Design System)

## Objetivo

Módulo que centraliza a identidade visual compartilhada por todos os apps. Garante que
`apps/*` tenham a **mesma identidade visual**, variando apenas **paleta de cores** e
**logo** por app. É a peça de Lego visual da qual quase todos os outros módulos de UI
dependem.

## Escopo / Responsabilidades

- **Design tokens**: cores, tipografia (fonts empacotadas no módulo), espaçamentos,
  raios, elevações, durações de animação.
- **Tema**: `ThemeData` claro/escuro derivado dos tokens, expostos via `ThemeExtension`.
  Os apps **sobrescrevem** um subconjunto customizável (**paleta, fontes e logo**) e podem
  **estender** com tokens próprios; os demais tokens (espaçamentos, raios, elevações,
  comportamento dos componentes) permanecem **fixos**, garantindo a mesma identidade
  visual entre apps (contrato de theming definido no Propose 1).
- **Componentes**: biblioteca de widgets reutilizáveis (botões, inputs, cards, listas,
  app bars, estados de loading/empty/error, dialogs, etc.).
- **Assets**: logo default e slots para logo por app; ícones base.

## Injeção / Configuração

O app injeta seu tema: override do subconjunto customizável (paleta, fontes, logo) e,
opcionalmente, `ThemeExtension`s adicionais para tokens próprios. O módulo não conhece
nenhum app específico; componentes compartilhados consomem apenas os tokens padrão.

## Standalone (`example/`)

App exemplo tipo "galeria/catálogo" que renderiza todos os componentes e ambos os temas
(claro/escuro) com uma paleta mock, servindo como storybook visual e base de golden tests.

## Dependências

- Base (Propose 1). Sem dependência de outros `vm_*`.

## Testes

- Golden tests de componentes e temas. Widget tests de estados (loading/empty/error).

## Critérios de sucesso

- Trocar paleta, fontes e logo produz um app visualmente distinto sem alterar componentes.
- `example/` compila standalone e cobre todos os componentes.

## Fora de escopo

- Lógica de negócio, navegação, dados.
