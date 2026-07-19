# Propose 4 — vm_storage (Armazenamento Local)

## Objetivo

Abstração unificada e injetável para persistência local, escondendo a implementação
concreta (shared_preferences, secure_storage, Hive/Isar) atrás de uma API estável.

## Escopo / Responsabilidades

- **Key-Value store** simples (preferências/flags leves).
- **Secure store** para dados sensíveis (tokens, credenciais).
- **Structured/cache store** opcional para coleções (Hive/Isar) com TTL.
- Interface única `Storage` com backends plugáveis; serialização via Freezed/Json.

## Injeção / Configuração

App escolhe e injeta os backends desejados (nem todo app precisa de secure/estruturado).
Namespacing de chaves por app/módulo para evitar colisão.

## Standalone (`example/`)

App exemplo com CRUD de preferências e de um item seguro, demonstrando os três stores.

## Dependências

- Base (Propose 1). Sem dependência de outros `vm_*`.

## Testes

- Unit tests com implementações fake/in-memory dos backends.

## Critérios de sucesso

- Trocar backend não afeta consumidores.
- Dados sensíveis nunca caem no store não seguro.

## Fora de escopo

- Sincronização remota, banco de dados de servidor.
