# Propose 12 — vm_tabbar (Navegação por Tabs)

## Objetivo

Componente/serviço de navegação por abas reutilizável, integrado ao vm_storyboard e ao
vm_navigation, permitindo que apps definam suas tabs por configuração.

## Escopo / Responsabilidades

- Shell de navegação por tabs (bottom bar) com estado preservado por aba.
- **Configuração declarativa** de tabs (ícone, label, rota/branch) injetada pelo app.
- Badges, tab ativa e deep link para aba/rota específica.
- Estilo derivado do tema do vm_storyboard.

## Injeção / Configuração

App fornece a lista de tabs e associa cada uma a um branch de rota (vm_navigation).
O módulo não conhece as telas concretas.

## Standalone (`example/`)

App exemplo com 3 tabs mock, badge e preservação de estado ao alternar.

## Dependências

- Base (Propose 1). Integra: vm_storyboard (estilo), vm_navigation (branches/rotas).

## Testes

- Widget tests de troca de aba e preservação de estado. Golden da bar.

## Critérios de sucesso

- Apps distintos configuram tabs diferentes sem alterar o módulo.
- Estado de cada aba é preservado ao navegar entre elas.

## Fora de escopo

- Lógica das telas dentro das abas.
