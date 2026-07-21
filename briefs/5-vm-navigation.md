# Propose 5 — vm_navigation (Roteamento)

## Objetivo

Wrapper padronizado sobre go_router que oferece rotas tipadas, guards e navegação
desacoplada, reutilizável por todos os apps e integrável com módulos que expõem rotas.

## Escopo / Responsabilidades

- **Rotas tipadas** e helper de registro (cada feature/módulo declara suas rotas).
- **Guards** (auth, feature flags) via callbacks injetáveis.
- **Deep link / redirect** básico.
- **Navigator service** injetável para navegação a partir de Cubits sem `BuildContext`.
- Integração com transições/tema do vm_storyboard.

## Injeção / Configuração

App compõe o roteador agregando as rotas dos módulos que ativou e injeta os guards
(ex.: estado de auth vindo do vm_auth).

## Standalone (`example/`)

App exemplo com 3 telas, rota guardada e deep link demonstrando o fluxo completo.

## Dependências

- Base (Propose 1). Opcional: vm_auth (guard), vm_storyboard (transições).

## Testes

- Unit tests de guards/redirect. Widget tests de navegação.

## Critérios de sucesso

- Um app agrega rotas de N módulos sem acoplamento entre eles.
- Navegação a partir de Cubit sem `context`.

## Fora de escopo

- UI de tabs (ver vm_tabbar), embora integre com ele.
