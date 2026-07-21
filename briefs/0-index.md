# Índice de Briefs — vm_core

Mapa da primeira leva de briefs (SDD / OpenSpec) para a base modular "Lego".
Cada arquivo é um brief independente para alimentar `/opsx:propose`.

## Visão geral

O objetivo é uma **caixa de peças de Lego reutilizáveis**: apps em `apps/*` consomem
módulos `packages/vm_*` **sob demanda**, com toda configuração **injetada** pelo app.
Cada módulo é **desacoplado, genérico e standalone** (compila isolado via `example/`,
com mocks quando preciso). Todos os apps compartilham a mesma identidade visual
(vm_storyboard), variando apenas paleta e logo.

## Briefs

| # | Arquivo | Papel |
|---|---------|-------|
| 1 | `1-base-estrutura-monorepo.md` | **Alicerce** — estrutura, DI, Barrel, theming, docs. Pré-requisito de todos |
| 2 | `2-vm-storyboard.md` | Design system (paleta + logo por app) |
| 3 | `3-vm-network.md` | HTTP + erros tipados |
| 4 | `4-vm-storage.md` | Persistência local (kv/secure/estruturado) |
| 5 | `5-vm-navigation.md` | go_router tipado + guards |
| 6 | `6-vm-localization.md` | i18n/l10n com merge por módulo |
| 7 | `7-vm-analytics.md` | Eventos, provider injetável |
| 8 | `8-vm-logging.md` | Logs estruturados, sinks plugáveis |
| 9 | `9-vm-auth.md` | Sessão/token, providers plugáveis |
| 10 | `10-vm-config.md` | Env + feature flags + remote config |
| 11 | `11-vm-admob.md` | Ads com chaves injetadas |
| 12 | `12-vm-tabbar.md` | Tabs declarativas |
| 13 | `13-vm-notifications.md` | Push + locais |
| 14 | `14-vm-connectivity.md` | Estado online/offline |

### Apps de exemplo (provam o modelo Lego)

| # | Arquivo | Papel |
|---|---------|-------|
| 15 | `15-app-weather.md` | App de clima — Open-Meteo (aberta), tema **padrão**, sem auth |
| 16 | `16-app-news.md` | App de notícias — Spaceflight News API (aberta), tema **sobrescrito** + vm_auth |

## Ordem de execução sugerida

Respeita as dependências entre módulos:

1. **`1`** — base/estrutura (obrigatório antes de qualquer módulo).
2. **`2` (storyboard)** e **`8` (logging)** — transversais, usados por quase todos.
3. **`3`, `4`, `5`** — network, storage, navigation (fundação funcional).
4. **`6`, `7`, `9`, `10`, `11`, `12`, `13`, `14`** — demais módulos, em qualquer ordem
   conforme necessidade (respeitando integrações citadas em cada brief).
5. **`15`, `16`** — apps de exemplo, **por último**: só fazem sentido depois que os
   módulos existem. Ambos consomem o máximo de módulos compartilhados, variando apenas
   paleta/logo, e cobrem casos complementares: **app_weather usa os tokens padrão** do
   storyboard (out-of-the-box) e **app_news sobrescreve** os tokens (paleta/fontes/logo
   próprios); ambos com API aberta, com/sem auth.

## Próxima leva (fora desta)

- Módulos Tier 3 sob demanda: `vm_permissions`, `vm_deeplink`, `vm_share`,
  `vm_in_app_review`, etc.

## Convenções

- Cada módulo segue o mesmo template: Objetivo · Escopo · Injeção · Standalone
  (`example/`) · Dependências · Testes · Critérios de sucesso · Fora de escopo.
- A base de contexto em `docs/` é **atualizada a cada novo módulo** criado.
