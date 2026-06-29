---
name: python-backend-architecture
description: Use when planning, implementing, or refactoring a Python backend where architecture, folder structure, layer boundaries, dependency direction, or maintainability must be defined and enforced before and during coding.
---

# Python Backend Architecture

Do not start Python backend work by writing `app.py`, `routes.py`, `models.py`, or `utils.py` in a flat layout.

Start with architecture.

This skill is not only for planning. It is also for enforcing architecture during implementation so the coding agent does not trade maintainability for short-term task completion.

## When to use

Use this skill when:

- starting a new Python backend project
- adding a substantial backend feature
- restructuring an existing backend
- implementing from an approved spec or plan
- reviewing whether a backend layout is maintainable
- a request mentions FastAPI, Flask, endpoints, models, services, repositories, schemas, workers, migrations, or backend architecture

Do not use this skill for tiny isolated fixes that do not affect structure, ownership, or dependency direction.

## Core goal

Prevent the agent from doing this:

```text
/project
├── app.py
├── models.py
├── routes.py
├── utils.py
```

That layout feels fast at first and usually decays into:

- mixed responsibilities
- large god files
- spaghetti imports
- business logic inside routes
- fragile tests
- weak ownership boundaries
- hard-to-maintain refactors

The objective is not only to finish the feature. The objective is to finish the feature inside a backend structure that remains understandable, testable, and extensible.

## Hard rules

### Rule 1: no implementation before architecture

Before coding, define at least:

1. target directory tree
2. layer responsibilities
3. dependency direction
4. testing structure
5. runtime entrypoints
6. migration approach if refactoring existing code

If this does not exist, stop and produce it first.

### Rule 2: spec and plan are binding inputs

If a superpower workflow already produced a `spec` and `plan.md`, do not treat them as ceremonial artifacts.

Implementation must actively follow them.

Before writing code, the agent must check:

- does the spec define the target architecture clearly enough?
- does the plan break work along module or layer boundaries?
- is the plan asking for code in a location that violates the architecture?

If the spec or plan is incomplete, contradictory, or structurally weak, fix the architecture first instead of coding through the problem.

### Rule 3: architecture must be enforced during coding

While implementing, the agent must continuously ask:

- does this file own this responsibility?
- am I putting business logic into the route layer?
- am I putting storage logic into the API layer?
- am I creating a god file?
- am I introducing an import path that weakens boundaries?
- am I growing a helper into a service without moving it?

Do not postpone these decisions until after the feature works.

### Rule 4: stop when architecture is missing or drifting

Stop implementation and repair the architecture first when any of these are true:

- the spec does not define a target directory tree
- the plan groups unrelated backend work into one large task
- the next edit would put business logic in an endpoint
- the next edit would put database or storage logic in the API layer
- a file is becoming a catch-all for multiple domains
- a compatibility shim has no removal plan
- tests can only be written by patching deep internals because layer boundaries are unclear

When stopped, report the architectural gap, propose the smallest correction, and continue only after the corrected structure is clear.

## Architectural principles

Every backend plan and implementation produced with this skill should preserve:

- Separation of concerns
- Scalability
- Testability
- Flexibility

Expanded meaning:

- Separation of concerns: logic, routes, config, persistence, and helpers live in distinct domains.
- Scalability: new features should fit the structure without rewriting the core.
- Testability: business logic should be testable outside the web framework.
- Flexibility: storage, auth, or framework choices should be swappable with localized changes.

## Standard blueprint

Default to this structure unless the existing codebase has a strong, coherent alternative:

```text
/your_project
├── app/
│   ├── api/
│   │   ├── v1/
│   │   │   ├── endpoints/
│   │   │   │   └── user.py
│   │   │   └── dependencies.py
│   ├── core/
│   │   ├── config.py
│   │   └── security.py
│   ├── models/
│   │   └── user.py
│   ├── schemas/
│   │   └── user.py
│   ├── services/
│   │   └── user_service.py
│   ├── repositories/
│   │   └── user_repo.py
│   ├── utils/
│   │   └── hashing.py
│   └── main.py
├── tests/
│   ├── unit/
│   └── integration/
├── migrations/
├── requirements.txt
├── .env
└── README.md
```

If the repo is not greenfield, adapt this blueprint to local naming conventions, but preserve the same architectural boundaries.

## Layer responsibilities

### `api/`

Purpose: request/response layer.

Allowed:

- accept HTTP requests
- validate inputs using schemas
- resolve dependencies
- delegate work to services
- shape HTTP responses

Not allowed:

- business logic
- storage logic
- persistence orchestration
- cross-domain workflow coordination

Rule of thumb: no business logic here.

### `core/`

Purpose: application-wide configuration and runtime concerns.

Typical contents:

- environment loading
- `BaseSettings` or equivalent configuration objects
- app startup/shutdown handlers
- CORS
- logging setup
- security helpers
- shared error and middleware wiring

### `models/`

Purpose: database-facing models or persistence/domain entities.

Typical examples:

- SQLAlchemy models
- Tortoise ORM models
- persistence entities

### `schemas/`

Purpose: API-facing request and response contracts.

Typical examples:

- Pydantic request bodies
- response DTOs
- external validation types

Keep `models/` and `schemas/` separate unless the codebase has a very deliberate reason not to.

### `services/`

Purpose: business logic.

Typical responsibilities:

- create user
- reset password
- send welcome email
- orchestrate multiple repositories or integrations
- implement use cases independent of HTTP details

This layer should be testable in isolation.

### `repositories/`

Purpose: abstract data access.

Typical responsibilities:

- hide ORM or database details
- expose focused methods such as `get_user_by_email()`
- keep storage logic out of API and service callers

This layer makes storage swaps and test doubles feasible.

### `utils/`

Purpose: small reusable helpers.

Examples:

- hashing
- token generation
- date formatting
- shared stateless helpers

Keep it light. If a helper grows feature-specific workflow logic, move it into `services/` or another owned module.

### `main.py`

Purpose: app entrypoint only.

Allowed:

- create app
- register routers
- configure middleware
- wire startup and shutdown
- launch server

Do not let `main.py` become a feature module.

## Project-level structure rules

### `tests/`

Testing is part of the architecture, not an afterthought.

Default structure:

```text
tests/
├── unit/
└── integration/
```

Guidelines:

- `unit/`: services, utils, pure business rules
- `integration/`: API + DB + end-to-end flows

The architecture is incomplete if testing structure is missing.

### `migrations/`

If the backend uses a relational database or managed schema evolution, include a dedicated migrations area.

Typical tool:

- Alembic

### `.env`

Environment-driven configuration should be expected, not bolted on later.

Typical configuration approach:

- `dotenv`
- `pydantic.BaseSettings` or equivalent settings model

### `requirements.txt`

If the project is dependency-file based, keep runtime requirements explicit and reviewable.

If the repo uses `pyproject.toml`, preserve the same principle with the local toolchain instead of forcing `requirements.txt`.

### `README.md`

The documented startup path must match the real architecture.

If backend structure or runtime dependencies change, update the README in the same change.

## Dependency direction

Prefer a direction like this:

```text
api -> services -> repositories
api -> schemas
services -> repositories
services -> models / integrations
core -> shared by multiple layers when appropriate
```

Avoid:

- `api -> repositories` for non-trivial use cases
- `repositories -> api`
- `schemas` treated as ORM models
- `main.py` owning feature logic
- circular imports between feature layers

## Required pre-implementation output

Before implementation begins, produce a short architecture spec.

Minimum format:

```text
Goal
Target directory tree
Layer boundaries
Dependency rules
Files to add or change
Test plan
Migration notes
```

If a spec already exists, validate that it covers these points before coding.

## Required plan quality

A valid implementation plan for backend work must:

- break tasks along layer or module boundaries
- avoid “just implement everything in X file” planning
- identify import migrations if files will move
- include test updates proportional to the blast radius
- identify runtime verification when startup paths or infrastructure are affected

If a plan is task-complete but architecture-weak, improve the plan before implementation.

## Spec-to-implementation alignment

Before finishing, compare implementation against the approved spec and plan. Use this table:

| Check | Required result |
|---|---|
| Target tree | Created or changed files match the planned structure |
| Layer boundaries | API, services, repositories, schemas, models, and core concerns remain separate |
| Dependency direction | Imports follow the planned direction and avoid circular dependencies |
| Business logic | Use cases live in services or equivalent business modules, not route handlers |
| Data access | Database and storage logic lives in repositories or explicit storage adapters |
| Tests | Unit and integration coverage match the risk and blast radius |
| Documentation | Startup and architecture docs match the final runtime behavior |
| Cleanup | Temporary compatibility code has a removal point or has already been removed |

If any row fails, fix the implementation or update the spec with an explicit rationale before declaring the work complete.

## Coding-phase enforcement

During implementation, follow these checks repeatedly.

### Before creating or editing a file

Ask:

- which layer owns this responsibility?
- is there already a coherent module for this?
- should this logic be split before I add more code?

### Before adding logic to a route

Ask:

- is this request parsing only, or real business behavior?
- if it is business behavior, why is it not in a service?

### Before adding data access code

Ask:

- should this live in a repository?
- am I leaking storage details into service or API layers?

### Before keeping a compatibility path

Ask:

- is this shim temporary and explicit?
- is there a cleanup point in the plan?
- can imports be migrated now instead of later?

### Before finishing

Ask:

- did I improve or degrade module boundaries?
- did I keep the code understandable at a glance?
- would a new engineer know where the next related change should go?

## Refactor triggers

Stop incremental coding and switch to structural planning when you see:

- a large `api.py`, `routes.py`, or `repositories.py`
- route handlers doing business logic
- database logic inside endpoint files
- background tasks mixed into API modules
- unclear ownership across users, projects, jobs, assets, workflows, or other domains
- import tangles or circular dependency risk
- tests that require deep monkey-patching because boundaries are weak
- adding one feature requires touching many unrelated modules

Read `references/refactor-signals.md` when these symptoms already exist.

## Implementation constraints

Once architecture is agreed:

- follow existing coherent local patterns where compatible with the blueprint
- keep files scoped to one responsibility
- update imports as part of the same architectural change
- keep compatibility shims temporary and explicit
- remove obsolete compatibility layers once migration completes
- do not accept “works for now” as a reason to keep a weak module boundary

## Review checklist

Before calling backend work complete, verify:

- routes are thin
- services own business logic
- repositories own data access
- schemas and models are separated
- config and startup concerns are centralized
- tests are split appropriately between unit and integration scope
- documentation matches runtime reality
- the resulting directory tree is still understandable at a glance
- the implementation still matches the approved spec and plan

Read `references/review-checklist.md` before merge.

## Suggested tools

This blueprint fits especially well with:

- FastAPI for API layer
- SQLAlchemy or Tortoise ORM for models
- Pydantic for request/response validation
- Alembic for migrations
- Uvicorn for app serving
- dotenv + `pydantic.BaseSettings` style config loading

Use equivalent local tools if the project already has a coherent stack.

## Recommended validation

For architecture-sensitive backend work, validate with some combination of:

- unit tests for services and utils
- integration tests for API + DB flows
- real startup verification of the app entrypoint
- import-path checks after refactors
- spec-to-implementation alignment checks
- README/startup command verification after structural changes

## References

Read these when needed:

- `references/architecture-blueprint.md`
- `references/implementation-flow.md`
- `references/acceptance-gates.md`
- `references/refactor-signals.md`
- `references/review-checklist.md`
