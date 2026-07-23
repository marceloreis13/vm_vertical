# Propose 6 — vm_localization (i18n / l10n)

## Objetivo

Módulo de internacionalização e formatação, permitindo que apps e módulos exponham e
consumam traduções de forma consistente, com troca de idioma em runtime.

## Escopo / Responsabilidades

- Infra de l10n (ARB + flutter gen-l10n) com convenção de chaves.
- **Merge de traduções por módulo, sem dependência de vm_localization**: cada módulo
  roda seu próprio `flutter gen-l10n` a partir de seus próprios ARBs, gerando uma classe
  tipada só sua (ex.: `VmStorageLocalizations`). O módulo expõe esse `delegate` +
  `supportedLocales` usando **apenas tipos do Flutter puro**
  (`LocalizationsDelegate`, `Locale`) — nenhum módulo importa `vm_localization`. O app é
  quem agrega manualmente esses delegates/locales na sua `MaterialApp`. Isso evita
  dependência circular: `vm_localization` já depende de `vm_storage` para persistir o
  locale (via ponto abaixo), então nenhum outro módulo pode depender de
  `vm_localization`.
- Formatação de datas, números e moedas por locale (intl).
- Cubit/serviço de idioma: mantém o locale ativo e notifica a árvore acima (a
  `MaterialApp` observa esse Cubit para trocar `locale:` em runtime). Persistência via
  `LocaleRepository` (interface de domínio): implementação **in-memory** por padrão
  (reseta para o default a cada restart) e uma implementação **vm_storage-backed**
  (usa `KeyValueStore`) habilitada por configuração — mesmo padrão de opt-in do
  `VmStorageConfig` (`enableSecureStore` etc).

## Injeção / Configuração

App injeta locales suportados, locale default e (opcional) habilita persistência via
vm_storage. Módulos **não** se registram em vm_localization — cada um só expõe seu
próprio delegate/supportedLocales gerados, que o app soma aos da MaterialApp.

## Standalone (`example/`)

App exemplo com seletor de idioma trocando textos e formatos em runtime. Locales
padrão: `pt_BR` (default) e `en`.

## Retrofit dos módulos existentes (parte deste change)

As demos de `vm_storage`, `vm_network` e `vm_navigation` passam a usar ARBs + gen-l10n
próprios (extraindo as strings hoje hard-coded de suas telas de demo), provando o
critério de sucesso abaixo com casos reais, não só um mock isolado.

## Dependências

- Base (Propose 1). Opcional: vm_storage (persistir locale).

## Testes

- Unit tests de resolução de locale e formatação. Golden de textos em `pt_BR` e `en`.

## Critérios de sucesso

- Módulo consegue fornecer strings sem o app conhecer suas chaves internas, e sem
  importar vm_localization.
- Troca de idioma em runtime reflete em todos os módulos ativos (via `MaterialApp`
  reagindo ao Cubit de locale).

## Fora de escopo

- Tradução automática, backend de i18n.
