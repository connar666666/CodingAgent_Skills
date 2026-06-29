# Review Checklist

Use this checklist before merging Python backend work.

## Architecture

- Does each new file have one clear ownership boundary?
- Did the change avoid creating or extending a god file?
- Is the directory structure still understandable at a glance?

## Layering

- Are route handlers thin?
- Is business logic in services?
- Is storage logic in repositories?
- Are models and schemas still separated?
- Are shared concerns in core rather than duplicated?

## Imports

- Do imports follow the intended dependency direction?
- Were all moved-module imports updated?
- If temporary compatibility modules were added, are they explicit and tracked for removal?

## Testing

- Were unit tests added or updated where behavior changed?
- Were integration tests updated for API, database, or startup-path changes?
- Is the validation proportional to the blast radius?

## Runtime

- Does the documented startup path still work?
- If configuration changed, was documentation updated?
- If external services are required, are they documented clearly?
