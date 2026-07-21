# Propose 6 — vm_localization (i18n / l10n)

## Objetivo

Módulo de internacionalização e formatação, permitindo que apps e módulos exponham e
consumam traduções de forma consistente, com troca de idioma em runtime.

## Escopo / Responsabilidades

- Infra de l10n (ARB + flutter gen-l10n) com convenção de chaves.
- **Merge de traduções por módulo**: cada módulo pode fornecer seu próprio conjunto de
  strings, agregado pelo app.
- Formatação de datas, números e moedas por locale (intl).
- Cubit/serviço de idioma com persistência do locale escolhido (via vm_storage).

## Injeção / Configuração

App injeta locales suportados e locale default; módulos registram seus catálogos.

## Standalone (`example/`)

App exemplo com seletor de idioma trocando textos e formatos em runtime.

## Dependências

- Base (Propose 1). Opcional: vm_storage (persistir locale).

## Testes

- Unit tests de resolução de locale e formatação. Golden de textos em 2 idiomas.

## Critérios de sucesso

- Módulo consegue fornecer strings sem o app conhecer suas chaves internas.
- Troca de idioma em runtime reflete em todos os módulos ativos.

## Fora de escopo

- Tradução automática, backend de i18n.
