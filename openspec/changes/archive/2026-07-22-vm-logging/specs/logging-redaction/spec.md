## ADDED Requirements

### Requirement: Redaction runs before any sink

Redaction SHALL be applied to a log entry before it is delivered to any sink. Sinks SHALL
only ever receive already-redacted entries, so sensitive data is never logged in clear
regardless of the destination.

#### Scenario: Sinks observe only redacted entries

- **WHEN** an entry containing sensitive data is emitted with any sinks registered
- **THEN** every sink SHALL receive the entry with the sensitive data already masked

### Requirement: Sensitive keys redacted by default

The app SHALL inject a set of sensitive field keys (e.g. `password`, `token`,
`authorization`). Any `fields` entry whose key matches a sensitive key SHALL have its value
replaced by a redaction placeholder before reaching any sink. Matching SHALL be
case-insensitive.

#### Scenario: Sensitive field value is masked

- **WHEN** `info('login', fields: {'password': 'hunter2'})` is emitted and `password` is a configured sensitive key
- **THEN** the delivered entry's `password` value SHALL be a redaction placeholder and never `hunter2`

#### Scenario: Non-sensitive fields are preserved

- **WHEN** an entry carries both a sensitive and a non-sensitive field
- **THEN** only the sensitive field SHALL be masked and the other SHALL be delivered unchanged

### Requirement: Pluggable redactors over values and message

The app SHALL be able to register additional redactors (e.g. regex-based) that run over field
values and over the message string. A registered redactor SHALL be able to mask matched
substrings anywhere they appear, independent of the field key.

#### Scenario: Regex redactor masks a matched pattern in the message

- **WHEN** a redactor matching email addresses is registered and a message contains one
- **THEN** the delivered message SHALL have the email replaced by a redaction placeholder

#### Scenario: Redactor masks a value under a non-sensitive key

- **WHEN** a card-number redactor is registered and a card number appears in a non-sensitive field's value
- **THEN** the delivered field value SHALL have the card number masked
