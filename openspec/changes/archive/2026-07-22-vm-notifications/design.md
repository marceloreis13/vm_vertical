## Context

The monorepo grows by adding decoupled `vm_*` Lego modules: each is provider-agnostic,
receives its configuration injected by the consuming app, and compiles standalone through
its `example/`. `vm_notifications` is the notification module (brief 13): push (token,
foreground/background reception, tap→deep link) plus local notifications (scheduling,
channels). Two of its integrations — routing on tap (`vm_navigation`) and an on/off gate
(`vm_config`) — touch modules that must stay decoupled, and one integration
(`vm_permissions`) does not exist yet. The design mirrors the seam approach already used by
`vm_config` (its `ConfigCache` port) rather than the hard-dependency approach used by
`vm_analytics` (its `vm_navigation` screen tracking), because notification routing must not
pin the module to the app's concrete routes.

## Goals / Non-Goals

**Goals:**
- One vendor-free `NotificationService` facade unifying push and local notifications.
- Swap the concrete provider (Firebase, APNs, `flutter_local_notifications`) without
  touching any call site.
- Route a tapped notification to the correct destination without the module depending on
  `vm_navigation` or knowing the app's routes.
- Ship a single in-memory `fake` provider so tests and `example/` run with no native plugin.
- Isolate provider failures behind a typed `Result`/`NotificationFailure`.

**Non-Goals:**
- Concrete vendor providers and the push-sending backend (out of scope; `fake` only).
- Notification permission flow — assumed granted; a seam is left for a future
  `vm_permissions` module.
- Rich local-notification features beyond schedule/cancel and channels/categories.
- Any hard dependency on `vm_navigation` or `vm_config`.

## Decisions

**1. Tap→route via an injected `NotificationRouter` seam (not a hard dep on `vm_navigation`).**
The module exposes `typedef NotificationRouter = Future<void> Function(NotificationPayload)`
and invokes it on tap. The app wires it to its navigator service and owns the payload→route
mapping. Rationale: notification routing is inherently app-specific (the module cannot
reference the app's typed routes); a callback keeps the module reusable and testable with a
fake. Alternative considered: hard dep on `vm_navigation` + injected payload→typed-route
mapper (the `vm_analytics` pattern). Rejected because it pins `vm_notifications` to
`vm_navigation` transitively for every consumer and still needs an app-provided mapper.

**2. Enable gate via an injected `enabled` predicate (not a hard dep on `vm_config`).**
`VmNotificationsConfig` carries an optional `bool Function() enabled` defaulting to
always-on. The service checks it before scheduling/handling. The app may wire it to a
`vm_config` flag. Rationale: keeps the gate decoupled and the default frictionless.
Alternative: hard dep on `vm_config` read internally — rejected for the same coupling reason.

**3. One `NotificationService` facade over two ports (`PushProvider` + `LocalScheduler`).**
A single consumer-facing facade unifies the two native concerns while the ports keep them
independently implementable and fakeable. Rationale: call sites want one entry point;
push and local have genuinely different native surfaces, so two ports keep each cohesive. A
single `FakeNotificationProvider` implements both ports for tests/`example`. Alternative:
two separate facades (`PushService`, `LocalService`) — rejected as more API surface for
little gain; consumers routinely need both together.

**4. Typed failures via `Result<T, NotificationFailure>`.**
Provider operations that can fail (scheduling, token fetch) return a `Result`; the facade
catches provider exceptions and maps them to a sealed `NotificationFailure`, never throwing
into the call site. Consistent with `vm_network`/`vm_storage` failure conventions. The
message/tap streams are best-effort (`Stream<NotificationPayload>`), errors logged via a
`dart:developer` seam earmarked for a future `vm_logging`.

**5. Permissions assumed granted, with a seam for later.**
No permission API in this change; the `PushProvider` port has room for a permission call so a
future `vm_permissions` integration or a concrete provider can add it without breaking the
facade.

## Risks / Trade-offs

- [Fake-only provider can hide native quirks (background isolates, channel setup on
  Android, APNs entitlements)] → The port contracts model the foreground/background and
  channel concepts explicitly so a concrete provider slots in; native validation lands with
  the first real provider change, out of scope here.
- [Assuming permission granted will surface no prompt in a real app] → Documented as an
  explicit non-goal and seam; the first real integration (or `vm_permissions`) adds it
  without touching the facade contract.
- [The injected `NotificationRouter` runs app code from module context] → Contract is a
  plain async callback; the module awaits it and isolates thrown errors, so a faulty handler
  cannot crash notification handling.
- [Two ports behind one facade could drift] → A single `FakeNotificationProvider`
  implementing both, plus per-port unit tests, keeps the contract honest.

## Migration Plan

New additive module; no existing spec requirements change. Add `packages/vm_notifications`
to the root `workspace:` list, register it in `docs/`. Rollback is removing the package and
its workspace/doc entries — no consumer depends on it yet.

## Open Questions

- None blocking. The concrete provider choice (Firebase Messaging vs. others) and the
  `vm_permissions` integration are deferred to later changes by design.
