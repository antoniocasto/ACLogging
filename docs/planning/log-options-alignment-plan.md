# Log Options Alignment Plan

- [x] Verify that `main` and `develop` exist and start a work branch from `develop`.
- [x] Recover the previous granular `LoggableEvent` log options work from local branches, including `LogOptions`, `LogParameterPrivacy`, and identity-specific APIs. Candidate branch: `codex/log-options-privacy`.
- [x] Align core sources, OSLog adapter behavior, test support, and tests with the recovered API.
- [x] Update README, CHANGELOG, public docs, and DocC examples so `shouldPrintParameters` is replaced by per-event parameter privacy.
- [x] Repair catalog source/project membership, preserving existing local package-reference changes where possible.
- [x] Run package tests, DocC/build checks where available, and an Xcode catalog build.
- [ ] Publish through the repository flow: commit, push, open PR to `develop`, then integrate `develop` into `main` through the required process.
