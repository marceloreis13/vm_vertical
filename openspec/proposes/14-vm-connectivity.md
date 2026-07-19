# Propose 14 — vm_connectivity (Status de Rede / Offline)

## Objetivo

Módulo que expõe o estado de conectividade da aplicação de forma observável e injetável,
permitindo que outros módulos e a UI reajam a online/offline.

## Escopo / Responsabilidades

- Detecção de conectividade (wifi/celular/none) e de acesso real à internet.
- **Estado observável** (Cubit/stream) consumível por qualquer módulo.
- Helpers/widgets de UI para banner offline (via vm_storyboard).
- Ponte opcional com vm_network (pausar/retomar requests, política offline).

## Injeção / Configuração

App injeta a fonte de conectividade (real ou fake) e a política desejada. Módulos apenas
observam o estado.

## Standalone (`example/`)

App exemplo com fonte fake alternando online/offline e refletindo na UI.

## Dependências

- Base (Propose 1). Integra: vm_storyboard (banner), vm_network (política offline).

## Testes

- Unit tests de transições de estado com fonte fake.

## Critérios de sucesso

- Módulos reagem a offline sem acoplamento ao pacote de conectividade concreto.
- Banner offline aparece/some conforme o estado.

## Fora de escopo

- Fila de sincronização offline complexa (pode virar módulo próprio depois).
