# Propose 3 — vm_network (Camada de Rede)

## Objetivo

Fornecer um cliente HTTP genérico, desacoplado e configurável por injeção, com
tratamento de erro padronizado, reutilizável por qualquer app ou módulo que precise
consumir APIs.

## Escopo / Responsabilidades

- **Cliente HTTP** abstrato (implementação sobre Dio ou http), com métodos REST.
- **Interceptors**: auth token (injetável), logging (via vm_logging quando presente),
  retry/backoff, headers padrão.
- **Modelo de resultado/erro**: tipo `Result`/`Either` (sucesso/falha) e taxonomia de
  falhas (rede, timeout, servidor, parsing, não autorizado).
- **Serialização**: integração com Freezed + JsonSerializable dos models do consumidor.

## Injeção / Configuração

App injeta: `baseUrl`, headers/env, provedor de token de auth, timeouts, flags de
logging. Nenhum endpoint específico de app vive aqui.

## Standalone (`example/`)

App exemplo que consome uma API pública (ou um mock server local) e exibe respostas,
demonstrando sucesso, erro e retry. Devem existir exemplos de conexoes diversas como: Conexão direta (consumo de api publica), conexao com use de credenciais, conexao com o uso de bearer token, e outros tipos que existir que sejam relevantes e tenham api publica para usarmos.

## Dependências

- Base (Propose 1). Opcional: vm_logging (Propose 8) para logs de request/response.

## Testes

- Unit tests de interceptors, mapeamento de erro e serialização (com mocks de HTTP).

## Critérios de sucesso

- Consumido por 2+ módulos/apps sem alteração no core.
- Erros de rede sempre chegam como falhas tipadas, nunca exceções cruas.

## Fora de escopo

- Cache de dados de domínio, persistência local (ver vm_storage).
