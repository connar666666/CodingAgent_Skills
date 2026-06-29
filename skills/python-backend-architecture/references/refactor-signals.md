# Refactor Signals

Use these signals to decide when a Python backend needs structural refactoring instead of another incremental patch.

## Strong signals

- a single API file contains route registration, schemas, startup, auth, and integrations
- a single repository file owns unrelated domains like users, projects, jobs, and assets
- route handlers perform storage logic and business logic directly
- imports are hard to untangle without circular dependency risk
- tests require monkey-patching internal helpers across unrelated layers

## Medium signals

- adding one feature means touching many unrelated files
- naming stops matching ownership boundaries
- the codebase has both old and new import paths with no cleanup plan
- workers, integrations, and API code depend on each other in both directions

## Refactor response

When these signals appear:

1. stop adding more feature code to the god file
2. define target layers and ownership
3. plan module migration order
4. preserve runtime behavior while moving code
5. remove temporary shims after imports are migrated
