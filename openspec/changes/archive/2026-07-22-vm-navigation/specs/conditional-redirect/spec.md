## ADDED Requirements

### Requirement: Redirect on guard failure

The module SHALL resolve a failing route guard through `go_router`'s `redirect`
mechanism, sending navigation to a fallback route configured alongside the guard,
instead of rendering the protected screen.

#### Scenario: Blocked route redirects to fallback

- **WHEN** a user navigates to a route whose guard predicate returns false
- **THEN** navigation redirects to the configured fallback route instead of building
  the protected route's screen

#### Scenario: Allowed route does not redirect

- **WHEN** a user navigates to a guarded route whose guard predicate returns true
- **THEN** the protected route's screen is built normally with no redirect

### Requirement: No external URI/deep-link parsing

The module SHALL limit "deep link" behavior to the conditional redirect described
above. It SHALL NOT parse or resolve external URIs, custom URL schemes, or platform
App Links/Universal Links.

#### Scenario: External URI parsing is out of scope

- **WHEN** an app needs to map an external URI (e.g., a custom scheme link) to a route
- **THEN** `vm_navigation` provides no built-in mechanism for this; the app or a future
  `vm_deeplink` module must supply it
