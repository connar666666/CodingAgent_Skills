# Acceptance Gates

Use these gates before claiming Python backend work is complete.

## Gate 1: architecture input exists

Pass only if the work has an explicit architecture spec or an existing coherent architecture that the change follows.

Required evidence:

- target directory tree
- layer responsibilities
- dependency direction
- test plan

## Gate 2: plan respects layers

Pass only if implementation tasks map to clear backend layers.

Fail examples:

- one task says to implement all backend behavior in a route file
- repository, service, and schema work are mixed with no boundary
- startup or infrastructure changes have no verification step

## Gate 3: implementation preserves ownership

Pass only if changed files still have clear responsibility.

Fail examples:

- endpoint contains business workflow logic
- service contains raw HTTP response shaping
- repository imports route or schema modules unnecessarily
- helper module grows feature-specific orchestration

## Gate 4: imports match dependency direction

Pass only if imports follow the planned direction and no new circular dependency risk appears.

Typical expected direction:

```text
api -> services -> repositories
api -> schemas
services -> repositories / integrations / models
core -> shared configuration and runtime concerns
```

## Gate 5: tests match risk

Pass only if testing is proportional to the change.

- narrow pure logic change: unit tests may be enough
- API contract change: API tests required
- persistence change: repository or integration tests required
- startup or infrastructure change: startup verification required

## Gate 6: docs match runtime

Pass only if README or startup docs still match the real command path, dependencies, ports, and environment variables.

## Stop condition

If any gate fails, do not summarize the task as complete. Fix the architecture drift or explicitly ask for a decision when the correction changes scope.
