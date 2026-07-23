# network-configuration

## Purpose

Defines how `vm_network` is configured and wired by consuming apps: the injected
`VmNetworkConfig` object, the single DI registration entry point, the standalone
visual example app, and how custom interceptors flow from config into the client.

## Requirements

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

### Requirement: Single DI registration entry point

The barrel SHALL expose one registration function (GetIt + Injectable convention) that
receives the `VmNetworkConfig` from the consuming app and registers the HTTP client and
its collaborators. Consumers SHALL resolve the client from the container by its public
abstract type.

#### Scenario: Registration wires the client

- **WHEN** the app calls the registration function with a valid config
- **THEN** the container SHALL resolve the client abstraction backed by the configured implementation

#### Scenario: Config supplied by app, not the module

- **WHEN** registration is invoked
- **THEN** the config SHALL be taken from the passed parameter, not read from module-internal constants

### Requirement: Standalone visual example

The module SHALL ship an `example/` app that compiles and runs without depending on any app
under `apps/`, with its screens and sections built from `vm_storyboard` components. It SHALL
visually demonstrate at least three connection styles against public APIs: a direct
public-API call (no auth), a credentialed call (basic auth), and a bearer-token call. It
SHALL also demonstrate explicit error scenarios and the interceptors in action. The example
SHALL surface success, error, and retry states on screen and keep any mocked inputs easy to
tweak. Any generic UI component missing from the design system SHALL be promoted to
`vm_storyboard` rather than built locally.

#### Scenario: Direct public API scenario

- **WHEN** the user triggers the direct public-API demo
- **THEN** the example SHALL perform the request and display the success or typed-failure state

#### Scenario: Credentialed (basic auth) scenario

- **WHEN** the user triggers the basic-auth demo
- **THEN** the example SHALL send credentials and display the resulting state

#### Scenario: Bearer-token scenario

- **WHEN** the user triggers the bearer-token demo
- **THEN** the example SHALL attach the token via the auth interceptor and display the resulting state

#### Scenario: Retry visibly demonstrated

- **WHEN** the user triggers a scenario that fails transiently
- **THEN** the example SHALL show the retry taking place and the final success or failure state

#### Scenario: Server error scenarios (404/500)

- **WHEN** the user triggers the 404 and 500 demos
- **THEN** the example SHALL display the corresponding server `Failure` with its status code

#### Scenario: Unauthorized error scenario (401)

- **WHEN** the user triggers the unauthorized demo (bad credentials/token)
- **THEN** the example SHALL display the unauthorized `Failure` state

#### Scenario: Timeout error scenario

- **WHEN** the user triggers the timeout demo (slow endpoint vs short timeout)
- **THEN** the example SHALL display the timeout `Failure` state

#### Scenario: Interceptors made observable

- **WHEN** the user runs the bearer and custom-interceptor demos
- **THEN** the example SHALL make visible that the auth token was attached and that a custom interceptor's effect was applied

### Requirement: Custom interceptors configurable at registration

The registration SHALL pass any custom interceptors from `VmNetworkConfig` into the client so
they participate in the request chain. When none are supplied, only built-in interceptors
SHALL be active.

#### Scenario: Config custom interceptors reach the client

- **WHEN** the app registers the module with one or more custom interceptors in the config
- **THEN** those interceptors SHALL be active on requests issued by the resolved client
