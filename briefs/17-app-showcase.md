# Propose 17 — app_showcase (App Vitrine dos Módulos)

## Objetivo

Terceiro app de referência da base Lego. Uma **vitrine/catálogo** que importa e monta,
em um único app navegável, a demo de **cada módulo `vm_*` existente** — sem reescrever
nenhum exemplo. Serve como documentação executável "o que a base oferece hoje" e como
QA visual rápido: qualquer regressão em um módulo aparece aqui.

## Como funciona a reutilização de exemplos

Não duplica código de exemplo. Reaproveita a convenção já validada pelo `vm_storyboard`:
a tela de demonstração de cada módulo (`XyzGalleryScreen` / `XyzExampleScreen`) vive no
próprio `lib/` do módulo e é exportada pelo barrel — `example/` de cada módulo é só uma
casca fina que registra config mock e chama esse widget.

- `app_showcase` **depende normalmente** de cada `vm_*` (como qualquer app faria) e
  importa o widget de demo de cada um pelo barrel — nenhuma dependência em `example/` de
  outro pacote.
- Cada módulo entra na vitrine como **um item de catálogo**: nome, ícone/descrição curta
  e a tela de demo embutida (via `vm_navigation`/`vm_tabbar`, ou lista → detalhe).
- Módulos que já têm config obrigatória (`registerVmXModule`) recebem, no `app_showcase`,
  a **mesma config mock** que seu próprio `example/` usa — reaproveitada, não recriada.
- **Pré-requisito retroativo**: todo módulo (novo ou já implementado) precisa expor sua
  tela de demo pelo barrel. Formalizado em `docs/module-scaffold.md`.

## Funcionalidades (mínimas)

- Tela inicial em grade/lista com um card por módulo `vm_*` disponível.
- Ao abrir um card, navega para a tela de demo daquele módulo (embutida, não um app à parte).
- Alternância de tema claro/escuro compartilhada com todos os módulos abertos.
- Busca/filtro simples por nome de módulo (útil conforme a lista cresce).

## Módulos consumidos (máximo reuso)

| Módulo | Uso no app |
|--------|-----------|
| vm_storyboard | Tema padrão + `GalleryScreen` como um dos itens do catálogo |
| vm_navigation | Rotas entre catálogo e cada demo de módulo |
| vm_tabbar ou navegação em lista | Estrutura do catálogo |
| vm_logging | Diagnóstico |
| Todos os demais `vm_*` | Cada um entra como **um item do catálogo**, mostrando a própria demo |

Não sobrescreve tema (como app_weather) — o foco é mostrar os módulos, não provar
customização visual (isso já é coberto pelo app_news).

## Configuração injetada

Config mock de cada módulo, replicada 1:1 da config que o `example/` do próprio módulo já
usa (mesmos valores, para não introduzir uma terceira fonte de mocks a manter).

## Critérios de sucesso

- Compila e roda consumindo só os módulos `vm_*`, sem copiar/reescrever nenhuma tela de
  exemplo — cada demo é o mesmo widget que o `example/` do módulo usa.
- Adicionar um módulo novo à vitrine é **um item de catálogo + import**, nunca uma nova
  implementação de UI de exemplo.
- Regressão visual/funcional em um módulo aparece na vitrine sem esforço extra.

## Dependências

Todos os módulos existentes no momento em que este app for implementado (o catálogo
cresce conforme novos módulos são adicionados; não precisa esperar a lista completa de
Proposes 1–14).

## Fora de escopo

- Qualquer lógica de negócio própria além de listar/navegar entre demos.
- Publicação/distribuição — é uma ferramenta interna de dev, não um app final.
