# Propose 11 — vm_admob (Anúncios)

## Objetivo

Módulo de anúncios (Google AdMob) totalmente desacoplado, com todas as chaves e IDs de
unidade **injetados** pelo app consumidor, oferecendo widgets/API prontos para banner,
intersticial e rewarded.

## Escopo / Responsabilidades

- Inicialização do SDK e consentimento (UMP/GDPR) opcional.
- Formatos: banner (widget), intersticial, rewarded — com controle de ciclo de vida e
  fallback silencioso quando desabilitado.
- Gate por feature flag (integra vm_config) e por estado (ex.: usuário premium).

## Injeção / Configuração

App injeta: app ID, ad unit IDs por formato, modo de teste, e flag de ativação. Nenhum
ID vive no módulo. Em standalone/dev usa test ad units.

## Standalone (`example/`)

App exemplo exibindo banner, intersticial e rewarded com test ad units mockadas.

## Dependências

- Base (Propose 1). Opcional: vm_config (gate por flag), vm_storyboard (placeholder UI).

## Testes

- Unit tests de gating e ciclo de vida com SDK fake/mock.

## Critérios de sucesso

- App habilita ads apenas injetando chaves e uma flag.
- Desligar ads via flag não deixa resíduo de UI.

## Fora de escopo

- Mediação avançada, outros provedores de ads (extensível depois).
