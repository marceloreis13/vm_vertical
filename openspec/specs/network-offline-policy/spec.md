## Purpose

Define `vm_network`'s abstract connectivity gate seam and the offline request policy interceptor that holds and resumes requests around it, without introducing a dependency on `vm_connectivity`.

## Requirements

### Requirement: Abstract connectivity gate seam

`vm_network` SHALL define its own abstract connectivity **gate** that reports whether the app
is currently online, as an injectable seam. `vm_network` SHALL NOT import `vm_connectivity` or
any concrete connectivity package; the gate SHALL be fed by whatever online signal the app
supplies. When no gate is configured, the client SHALL behave exactly as before (no offline
gating).

#### Scenario: No gate configured is backwards compatible

- **WHEN** the client is registered without a connectivity gate
- **THEN** requests SHALL proceed unchanged with no offline handling

#### Scenario: No dependency on vm_connectivity

- **WHEN** `vm_network`'s dependencies are inspected
- **THEN** they SHALL NOT include `vm_connectivity` or `connectivity_plus`

### Requirement: Offline request policy interceptor

When a connectivity gate is configured, `vm_network` SHALL apply an offline request policy via
an interceptor: while the gate reports offline, outbound requests SHALL be held (not failed
immediately) according to the configured policy, and SHALL be resumed when the gate reports
online again. The policy SHALL bound the wait so a request does not hang indefinitely, failing
with a typed connectivity failure once the bound is exceeded.

#### Scenario: Request held while offline then resumed

- **WHEN** a request is issued while the gate reports offline and the gate returns to online within the policy bound
- **THEN** the request SHALL be held and then sent once online, without surfacing an error to the caller

#### Scenario: Bounded wait fails typed

- **WHEN** a request is held while offline and the gate does not return to online within the policy bound
- **THEN** the client SHALL complete with a typed connectivity/offline `Failure`, never a raw exception

#### Scenario: Online requests unaffected

- **WHEN** a request is issued while the gate reports online
- **THEN** it SHALL proceed immediately with no gating delay
