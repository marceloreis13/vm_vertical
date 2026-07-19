# Propose 9 — vm_auth (Autenticação)

## Objetivo

Módulo de autenticação e sessão desacoplado do provedor (Firebase Auth, OAuth, backend
próprio), expondo estado de sessão consumível por navegação, rede e UI.

## Escopo / Responsabilidades

- Fluxos: sign-in, sign-out, sign-up, refresh de token, recuperação de sessão.
- **Estado de sessão** (Cubit) observável (autenticado/anônimo/expirado).
- **Providers plugáveis** (email/senha, social, anônimo) via interface injetável.
- Armazenamento seguro de token (via vm_storage secure) e fornecimento de token ao
  vm_network (interceptor).

## Injeção / Configuração

App injeta o(s) provider(s) concretos e chaves. Guards de navegação leem o estado de
sessão exposto por este módulo.

## Standalone (`example/`)

App exemplo com login mock (provider fake), tela autenticada e logout.

## Dependências

- Base (Propose 1). Usa: vm_storage (token seguro). Integra: vm_network, vm_navigation.

## Testes

- Unit tests dos fluxos e transições de estado com provider fake.

## Critérios de sucesso

- Trocar provedor de auth não afeta guards nem UI.
- Token é fornecido ao vm_network sem acoplamento direto.

## Fora de escopo

- Gestão de usuários/perfil no servidor.
