# Propose 7 — vm_analytics (Rastreamento de Eventos)

## Objetivo

Abstração de analytics desacoplada do provedor (Firebase Analytics, Amplitude, etc.),
permitindo que apps e módulos emitam eventos por uma API única e injetem o provedor real.

## Escopo / Responsabilidades

- Interface `AnalyticsTracker` (logEvent, setUserProperty, screenView).
- **Providers plugáveis** e multiplexação (enviar para N provedores ao mesmo tempo).
- Provider `noop` e `debug` (loga em console) para dev/standalone.
- Convenção de nomenclatura de eventos e helpers para telas (integra com vm_navigation).

## Injeção / Configuração

App injeta os providers concretos e as chaves. Módulos apenas emitem eventos pela
interface, sem conhecer o provedor.

## Standalone (`example/`)

App exemplo que dispara eventos e os exibe via provider debug on-screen.

## Dependências

- Base (Propose 1). Opcional: vm_navigation (screen tracking), vm_logging.

## Testes

- Unit tests de multiplexação e mapeamento de eventos com providers fake.

## Critérios de sucesso

- Trocar/adicionar provedor não altera call sites.
- Módulos emitem eventos sem dependência de SDK específico.

## Fora de escopo

- Dashboards, análise de dados.
