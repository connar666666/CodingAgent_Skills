# CodingAgent Skills

Reusable engineering skills for coding agents. This repository is the source of truth for skills that can be installed into Codex, Claude Code, or other agents that support `SKILL.md`-style skill folders.

## Repository layout

```text
CodingAgent_Skills/
├── skills/
│   └── python-backend-architecture/
│       ├── SKILL.md
│       └── references/
├── scripts/
│   ├── install-codex.sh
│   └── install-claude.sh
├── install.sh
└── README.md
```

## Current skills

- `python-backend-architecture`: architecture-first and implementation-phase discipline for Python backend work.

## What the installer does

`install.sh` is the main installer entrypoint.

The files in `scripts/` are agent-specific installers used by `install.sh`:

- `install-codex.sh` installs the skill into a Codex skills directory
- `install-claude.sh` installs the skill into a Claude Code skills directory

The scripts support two modes:

1. Remote install from GitHub, no clone required.
2. Local install from a cloned checkout, useful when developing or updating skills.

## Quick install without cloning

### Codex

```bash
curl -fsSL https://raw.githubusercontent.com/connar666666/CodingAgent_Skills/main/install.sh | bash
```

Default target:

```text
~/.codex/skills/python-backend-architecture
```

### Claude Code

```bash
curl -fsSL https://raw.githubusercontent.com/connar666666/CodingAgent_Skills/main/install.sh | bash -s claude
```

Default target:

```text
~/.claude/skills/python-backend-architecture
```

## Install to a custom skills directory

Pass the target skills root as the first argument.

```bash
curl -fsSL https://raw.githubusercontent.com/connar666666/CodingAgent_Skills/main/install.sh | bash -s codex /path/to/codex/skills
```

```bash
curl -fsSL https://raw.githubusercontent.com/connar666666/CodingAgent_Skills/main/install.sh | bash -s claude /path/to/claude/skills
```

## Local development install

Clone the repository only if you want to maintain or edit the skills locally.

```bash
git clone https://github.com/connar666666/CodingAgent_Skills.git
cd CodingAgent_Skills
bash install.sh
bash install.sh claude
```

After editing skills locally, rerun the relevant installer script.

## Updating an installed skill

For regular users, rerun the one-line installer:

```bash
curl -fsSL https://raw.githubusercontent.com/connar666666/CodingAgent_Skills/main/install.sh | bash
```

For maintainers working from a clone:

```bash
git pull
bash install.sh
bash install.sh claude
```

## Installing a different branch or fork

The installers read these optional environment variables:

| Variable | Default | Purpose |
|---|---|---|
| `CODING_AGENT_SKILLS_REPO` | `connar666666/CodingAgent_Skills` | GitHub `owner/repo` to install from |
| `CODING_AGENT_SKILLS_REF` | `main` | Branch name to install from |
| `SKILL_NAME` | `python-backend-architecture` | Skill folder name to install |

Example:

```bash
curl -fsSL https://raw.githubusercontent.com/connar666666/CodingAgent_Skills/main/install.sh | CODING_AGENT_SKILLS_REF=dev bash
```

## Principles

- Keep each skill focused on one repeatable workflow.
- Put trigger rules and process in `SKILL.md`.
- Put long-form guidance in `references/`.
- Treat this repository as the source of truth; local installs are copies.
