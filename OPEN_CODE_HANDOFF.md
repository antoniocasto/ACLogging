# OpenCode Handoff

This file is the durable continuation point for OpenCode when Codex runs out of tokens or context, including future chats with no prior conversation history. Treat it as the conversation memory needed to continue as if the user were still talking to Codex.

## Continuity Snapshot

- Latest user intent: OpenCode must be able to continue the work like a Codex continuation, not merely find repository instructions.
- Active task: make handoff state carry conversation continuity across future chats.
- User preferences:
  - Italian is preferred for conversational replies.
  - Keep responses terse when the `caveman` skill is active.
  - Follow repository branch rules from `AGENTS.md`.
- Active assumptions:
  - OpenCode may start from a future chat with no prior transcript.
  - The repository files are the only durable memory unless a future agent updates them.
  - `OPEN_CODE_HANDOFF.md` must be updated before any agent stops.
- Decisions made:
  - Use `AGENTS.md` for durable repository rules.
  - Use `OPENCODE.md` as a root-level future-session entrypoint.
  - Use this file for live task state, user intent, decisions, and next action.
- What just happened:
  - User clarified that OpenCode must continue as if the conversation with Codex were still active.
  - A new branch `codex/opencode-conversation-continuity` was created from `develop`.
- What Codex would do next:
  - Finish strengthening this handoff, verify diff, commit the change, then integrate through `develop` and `main`.

## Current State

- Repository: `ACLogging`
- Current branch: `codex/opencode-conversation-continuity`
- Base branch: `develop`
- Required branches checked: `main` and `develop` exist
- Working tree at handoff creation: `develop` was ahead of `origin/develop` by the prior handoff commit
- Current task: make repository continuation state conversationally complete for OpenCode

## How To Resume

1. Read `AGENTS.md`.
2. Read `OPENCODE.md`.
3. Read the current plan in `plans/` if present.
4. Run:

```bash
git status --short --branch
git diff
```

5. Continue from `Continuity Snapshot`, then the first unchecked plan item, then `Next Codex-Equivalent Move`.
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

- User clarified that OpenCode must continue as if Codex conversation is still active.
- Created branch `codex/opencode-conversation-continuity` from `develop`.
- Added `plans/opencode-conversation-continuity-plan-2026-06-22.md`.
- Updated `AGENTS.md`, `OPENCODE.md`, and this file to require conversation-continuity fields.
- Verified documentation diff and repository state.

## Previous Task Log

- Created branch `codex/opencode-handoff` from `develop`.
- Added `plans/opencode-handoff-plan-2026-06-22.md`.
- Added `AGENTS.md`.
- Added `OPENCODE.md` as the root OpenCode entrypoint for future chats.
- Added this handoff file.
- Linked the handoff from `README.md` and `docs/README.md`.
- Linked the OpenCode entrypoint from `README.md` and `docs/README.md`.
- Verified `git status --short --branch` and the documentation diff.
- Note: `plans/` is ignored by `.gitignore`, so the local plan file is not shown as an untracked file.

## Next Codex-Equivalent Move

Commit this documentation-only continuity update, merge it into `develop`, then merge `develop` into `main`.
