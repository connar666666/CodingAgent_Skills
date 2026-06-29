# Implementation Flow

Use this flow when a coding agent already has a spec and plan but still needs architectural discipline during implementation.

## Phase 1: validate inputs

Before coding, inspect the spec and plan.

Questions:

- Does the spec define the target directory tree?
- Does it define layer ownership?
- Does it define dependency direction?
- Does it say where tests belong?
- If this is a refactor, does it explain import migration?

If not, repair the architecture inputs first.

## Phase 2: map tasks to layers

For each plan item, map it to one of:

- API
- Core
- Models
- Schemas
- Services
- Repositories
- Utils
- Tests
- Migrations
- Runtime / startup docs

If a task naturally spans several layers, split it.

## Phase 3: implement with boundary checks

Before each edit, ask:

- Is this the right file?
- Is this the right layer?
- Is this logic growing a god file?
- Am I mixing request concerns, business logic, and storage concerns?

If yes, stop and restructure before adding more code.

## Phase 4: enforce stop conditions

Stop coding and repair the architecture when:

- the implementation no longer matches the approved spec
- the plan would create a large catch-all module
- an endpoint starts owning business workflow logic
- repository, API, and service concerns are being mixed
- tests require brittle deep patching because boundaries are unclear

## Phase 5: verify architecture did not drift

After implementation, review:

- Did route files stay thin?
- Did services absorb business logic?
- Did repositories own data access?
- Did startup docs and runtime config stay accurate?
- Did imports move to the intended module boundaries?
- Does the implementation pass the acceptance gates?

See `acceptance-gates.md` for the final pass/fail checks.

## Failure mode to avoid

The most common failure is:

1. write a good spec
2. write a good plan
3. ignore both during implementation
4. finish a working feature inside a poor structure

This skill exists to prevent step 3.
