# Propose 16 — app_news (App de Exemplo: Notícias)

## Objetivo

Segundo app de referência da base Lego. Um leitor de notícias simples que **prova o
modelo** consumindo os mesmos módulos do app_weather, mas com identidade visual própria
(paleta + logo) e usando um módulo que o weather não usa (**vm_auth**, login opcional).

## API pública

- **Spaceflight News API v4** (`https://spaceflightnewsapi.net`) — notícias de
  tecnologia/espaço **sem chave de API**, gratuita. Fornece artigos com título, resumo,
  imagem, fonte e data, além de busca e paginação — rico o suficiente para uma UI de
  leitor com lista + detalhe.
- Sem chave, o `example/` e o CI compilam sem segredos; para build offline determinístico,
  usa dados mockados.
- Observação: o padrão de **injeção de chave/segredo** continua demonstrado na base pelo
  **vm_admob** (chaves de ad injetadas) e pelo **vm_config** (env/flags), sem depender
  de a API de notícias exigir chave.

## Funcionalidades (mínimas)

- Feed de artigos com busca, filtro por fonte/tipo (articles / blogs / reports) e detalhe.
- Salvar artigos (favoritos); com login opcional, sincroniza a lista.
- Estados de loading/empty/error e banner offline.

## Módulos consumidos (máximo reuso)

| Módulo | Uso no app |
|--------|-----------|
| vm_storyboard | Toda a UI **sobrescrevendo** o subconjunto customizável (paleta, fontes, logo próprios) |
| vm_network | Chamadas à Spaceflight News API |
| vm_storage | Artigos salvos + preferências (kv/estruturado) |
| vm_navigation | Rotas (Feed / Salvos / Detalhe), deep link |
| vm_tabbar | Navegação por abas |
| vm_localization | Textos e formatação por locale |
| vm_analytics | Eventos (abrir artigo, salvar, buscar) |
| vm_logging | Diagnóstico |
| vm_auth | Login opcional para sincronizar salvos (provider mock/social) |
| vm_config | Env + feature flags |
| vm_connectivity | Banner offline |
| vm_admob | Intersticial ao abrir detalhe (chaves injetadas; test units em dev) |
| vm_notifications | Push de "breaking news" abrindo o detalhe via deep link |

## Configuração injetada

**Override de tema** — injeta paleta, fontes e logo próprios do news (subconjunto
customizável), mantendo fixos os demais tokens. Injeta também: base URL da Spaceflight
News API (via vm_config), provider de auth, chaves do AdMob, flags, locales.

## Critérios de sucesso

- Compila e roda consumindo os mesmos módulos do app_weather + vm_auth.
- Usa a **mesma** biblioteca de componentes, mas **sobrescrevendo** os tokens (paleta,
  fontes, logo) — visualmente distinto do app_weather, que usa os tokens padrão.
- Demonstra feed com busca/paginação, deep link de notificação e login opcional.

## Dependências

Todos os módulos listados acima (Proposes 1–14 concluídos).

## Fora de escopo

- CMS/backend de notícias próprio, comentários, paywall.
