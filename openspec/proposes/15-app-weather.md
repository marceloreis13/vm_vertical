# Propose 15 — app_weather (App de Exemplo: Clima)

## Objetivo

Primeiro app de referência da base Lego. Um app de clima simples que **prova o modelo**:
é montado apenas combinando módulos `vm_*` existentes, com toda configuração injetada.
Serve como documentação executável de "como iniciar um app a partir da base".

## API pública

- **Open-Meteo** (`https://open-meteo.com`) — previsão do tempo **sem chave de API**,
  gratuita. Geocoding pela própria Open-Meteo Geocoding API.
- Escolha proposital de uma API sem chave para demonstrar o fluxo de rede sem segredo;
  o app de notícias (Propose 16) demonstra o fluxo **com** chave injetada.

## Funcionalidades (mínimas)

- Buscar cidade (geocoding) e ver clima atual + previsão de alguns dias.
- Lista de cidades salvas; unidade °C/°F alternável.
- Estados de loading/empty/error e banner offline.

## Módulos consumidos (máximo reuso)

| Módulo | Uso no app |
|--------|-----------|
| vm_storyboard | Toda a UI usando os **tokens padrão** do storyboard (sem override) |
| vm_network | Chamadas à Open-Meteo |
| vm_storage | Cidades salvas + unidade preferida (kv) |
| vm_navigation | Rotas (Hoje / Previsão / Cidades) |
| vm_tabbar | Navegação por abas |
| vm_localization | Textos e formatação de data/temperatura por locale |
| vm_analytics | Eventos (busca de cidade, troca de unidade) |
| vm_logging | Diagnóstico |
| vm_config | Feature flags (ex.: ligar/desligar previsão estendida) |
| vm_connectivity | Banner offline / política de rede |
| vm_admob | Banner na lista (chaves injetadas; test units em dev) |
| vm_notifications | Notificação local diária "clima de hoje" (opcional) |

Não usa vm_auth (app anônimo) — demonstra que módulos são **opcionais/sob demanda**.

## Configuração injetada

**Sem override de tema** — consome a paleta, fontes e logo **padrão** do vm_storyboard.
Injeta: endpoints/base URL da Open-Meteo, chaves do AdMob, flags, locales suportados.

## Critérios de sucesso

- Compila e roda consumindo só módulos da base, sem código de infra duplicado.
- Usa o tema **padrão** do storyboard sem nenhum override — prova que a base funciona
  out-of-the-box; contrasta com o app_news, que sobrescreve os tokens.
- Demonstra rede **sem chave**, cache local, offline e ads.

## Dependências

Todos os módulos listados acima (Proposes 1–14 concluídos).

## Fora de escopo

- Backend próprio, mapas, alertas meteorológicos avançados.
