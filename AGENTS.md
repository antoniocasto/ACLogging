# Agent Working Rules

This repository can be edited by Codex and OpenCode. Keep this file current when workflow rules change.

## First Step In Every New Agent Session

- Read [OPEN_CODE_HANDOFF.md](OPEN_CODE_HANDOFF.md) before doing any work.
- If [OPENCODE.md](OPENCODE.md) exists, treat it as a short alias that points back to this file and the handoff.
- Resume from the `Continuity Snapshot` and `Next Codex-Equivalent Move` sections in [OPEN_CODE_HANDOFF.md](OPEN_CODE_HANDOFF.md) unless the user gives a newer instruction.
- Update [OPEN_CODE_HANDOFF.md](OPEN_CODE_HANDOFF.md) before stopping so another agent can continue without chat history.

## Branch Flow

- Required branches: `main` and `develop`.
- Before starting feature work, verify both branches exist. If either is missing, report it before editing.
- Start every feature from `develop`:
  - switch to `develop`
  - update it from the remote when needed
  - create a dedicated branch with the `codex/` prefix unless the user asks for another name
- Integrate feature branches into `develop` first, then integrate `develop` into `main`.
- If integration happens on the remote, use pull requests: feature branch into `develop`, then `develop` into `main`.

## Planning

- Before editing, create or update a checklist plan under `plans/`.
- While working, update the plan by checking completed items.
- Keep plans short, concrete, and tied to the current task.

## Handoff

- Use [OPEN_CODE_HANDOFF.md](OPEN_CODE_HANDOFF.md) as the persistent continuation point.
- Update the handoff before stopping, before long-running tool work, and after major state changes.
- Include current branch, task, changed files, commands run, verification status, blockers, and the next exact step.
- Also include conversation continuity: latest user intent, active assumptions, decisions made, what was just done, what Codex would do next, and any user preferences that affect future replies.
- If context is lost, read this order first:
  1. `OPEN_CODE_HANDOFF.md`
  2. current task plan under `plans/`
  3. `git status --short --branch`
  4. recent diff with `git diff`

## Code Style

- Write code comments in English.
- Prefer existing project patterns over new abstractions.
- Keep changes scoped to the current task.
- Do not revert user changes unless explicitly asked.

## Public Repository Requirements

Public GitHub package repositories must keep:

- `README.md`
- `LICENSE.md`
- `CHANGELOG.md`
- `docs/`
