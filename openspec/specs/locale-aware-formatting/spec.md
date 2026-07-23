# locale-aware-formatting

## Purpose
`vm_localization` formats dates, numbers, and currency according to an explicitly
passed `Locale` (no ambient/global locale state), using `intl` under the hood, so any
module or app can render locale-correct values regardless of which locale is currently
active elsewhere.

## Requirements

### Requirement: Locale-aware date formatting
The module SHALL expose a date formatter that takes a `Locale` explicitly (no ambient/global locale state) and formats `DateTime` values according to that locale's conventions.

#### Scenario: Formatting a date in two locales
- **WHEN** the same `DateTime` is formatted once with `pt_BR` and once with `en`
- **THEN** the two outputs follow each locale's date convention (e.g. day/month order) and differ accordingly

### Requirement: Locale-aware number formatting
The module SHALL expose a number formatter that takes a `Locale` explicitly and formats numeric values according to that locale's grouping and decimal separator conventions.

#### Scenario: Formatting a number in two locales
- **WHEN** the same numeric value is formatted once with `pt_BR` and once with `en`
- **THEN** the two outputs use each locale's decimal/grouping separators and differ accordingly

### Requirement: Locale-aware currency formatting
The module SHALL expose a currency formatter that takes a `Locale` explicitly and formats a numeric value as currency, inferring the currency symbol/code from the given locale.

#### Scenario: Formatting currency in two locales
- **WHEN** the same numeric value is formatted as currency once with `pt_BR` and once with `en`
- **THEN** the two outputs use the currency symbol/format associated with each locale
