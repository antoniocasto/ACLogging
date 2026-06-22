# OpenCode Handoff

This file is the durable continuation point for OpenCode when Codex runs out of tokens or context, including future chats with no prior conversation history.

## Current State

- Repository: `ACLogging`
- Current branch: `codex/opencode-handoff`
- Base branch: `develop`
- Required branches checked: `main` and `develop` exist
- Working tree at handoff creation: clean before this documentation task
- Current task: make repository continuation state explicit for OpenCode

## How To Resume

1. Read `AGENTS.md`.
2. Read `OPENCODE.md`.
3. Read the current plan in `plans/` if present.
4. Run:

```bash
git status --short --branch
git diff
```

5. Continue from the first unchecked plan item, or from `Next Step` below if no plan is available.
6. Before stopping, update this file with latest state and next step.

## Project Shape

- Swift package with products:
  - `ACLogging`
  - `ACLoggingOSLog`
  - `ACLoggingSwiftUI`
  - `ACLoggingTestSupport`
- Main package manifest: `Package.swift`
- Core sources: `Sources/ACLogging/`
- Adapter sources:
  - `Sources/ACLoggingOSLog/`
  - `Sources/ACLoggingSwiftUI/`
- Tests:
  - `Tests/ACLoggingTests/`
  - `Tests/ACLoggingOSLogTests/`
  - `Tests/ACLoggingSwiftUITests/`
- Public docs:
  - `README.md`
  - `docs/`
  - `Sources/ACLogging/ACLogging.docc/`

## Common Verification

Use the narrowest useful verification for the change:

```bash
swift test
```

For Skip-related changes, also consider:

```bash
skip checkup --native
skip android test
```

For DocC or GitHub Pages changes, inspect the workflow and generated output before merging.

## Current Task Log

- Created branch `codex/opencode-handoff` from `develop`.
- Added `plans/opencode-handoff-plan-2026-06-22.md`.
- Added `AGENTS.md`.
- Added `OPENCODE.md` as the root OpenCode entrypoint for future chats.
- Added this handoff file.
- Linked the handoff from `README.md` and `docs/README.md`.
- Linked the OpenCode entrypoint from `README.md` and `docs/README.md`.
- Verified `git status --short --branch` and the documentation diff.
- Note: `plans/` is ignored by `.gitignore`, so the local plan file is not shown as an untracked file.

## Next Step

Review the documentation changes, run no tests unless requested because this is documentation-only, then commit when ready.
