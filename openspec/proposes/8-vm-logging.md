# Propose 8 — vm_logging (Logs Estruturados)

## Objetivo

Serviço de logging estruturado, injetável e com níveis, usado por módulos e apps para
diagnóstico consistente, com sinks plugáveis (console, arquivo, crash reporting).

## Escopo / Responsabilidades

- API de log com níveis (trace/debug/info/warn/error) e contexto estruturado.
- **Sinks plugáveis**: console (dev), no-op (prod silencioso), e ponte opcional para
  crash reporting (ex.: Crashlytics/Sentry) via provider injetável.
- Redação/masking de dados sensíveis.
- Integração opcional com vm_network (log de requests) e vm_analytics.

## Injeção / Configuração

App define nível mínimo por ambiente e injeta os sinks. Módulos recebem um `Logger`
via DI, sem conhecer o destino final.

## Standalone (`example/`)

App exemplo que emite logs em todos os níveis exibindo-os on-screen.

## Dependências

- Base (Propose 1). Sem dependência obrigatória de outros `vm_*`.

## Testes

- Unit tests de níveis, masking e roteamento para sinks fake.

## Critérios de sucesso

- Log de um módulo chega ao sink certo sem acoplamento ao provedor.
- Dados sensíveis nunca são logados em claro.

## Fora de escopo

- Agregação/observabilidade server-side.
