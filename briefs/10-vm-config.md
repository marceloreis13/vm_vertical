# Propose 10 — vm_config (Remote Config / Feature Flags / Env)

## Objetivo

Fonte única e injetável de configuração da aplicação: variáveis de ambiente, feature
flags e remote config, permitindo ligar/desligar módulos e comportamentos sem deploy.

## Escopo / Responsabilidades

- **Env**: configuração por ambiente (dev/staging/prod) tipada.
- **Feature flags**: leitura de flags com defaults locais e override remoto.
- **Remote config** plugável (ex.: Firebase Remote Config) via provider injetável, com
  fallback local e cache (via vm_storage).
- API observável para reagir a mudanças de flag em runtime.

## Injeção / Configuração

App injeta o provider remoto e os defaults. Módulos consultam flags pela interface, sem
conhecer a origem.

## Standalone (`example/`)

App exemplo com provider local que alterna flags e reflete na UI.

## Dependências

- Base (Propose 1). Opcional: vm_storage (cache de config).

## Testes

- Unit tests de resolução flag→valor com precedência remoto>cache>default.

## Critérios de sucesso

- Uma flag controla a ativação de um módulo sem alterar código do app.
- Falha do provider remoto cai para defaults locais sem quebrar.

## Fora de escopo

- Console de administração de flags.
