## MODIFIED Requirements

### Requirement: Injected configuration object

The module SHALL define a `VmNetworkConfig` carrying `baseUrl`, default headers, an
optional async token provider, connect/receive/send timeouts, a retry policy, a
logging flag, an optional ordered list of custom interceptors, an optional connectivity
**gate**, and an optional offline request **policy**. The module SHALL NOT
hard-code any app-specific endpoint or ambient global state; all configuration SHALL be
received from the consuming app. When the connectivity gate is omitted, the client SHALL
behave exactly as before with no offline gating.

#### Scenario: Config drives client behavior

- **WHEN** an app constructs a `VmNetworkConfig` with a given `baseUrl` and timeouts
- **THEN** the client SHALL use exactly those values for its requests

#### Scenario: No app endpoint inside the module

- **WHEN** the module source is inspected
- **THEN** it SHALL contain no hard-coded app-specific endpoint URL

#### Scenario: Optional connectivity gate wired from config

- **WHEN** an app supplies a connectivity gate and offline policy in the config
- **THEN** the client SHALL apply the offline request policy driven by that gate

#### Scenario: Absent gate is backwards compatible

- **WHEN** an app constructs a `VmNetworkConfig` without a connectivity gate
- **THEN** the client SHALL issue requests with no offline gating, identical to prior behavior
