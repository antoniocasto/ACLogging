# Versioning and Releases

ACLogging uses Semantic Versioning for package releases, Git tags, GitHub releases, changelog sections, and documentation references.

## Version Format

Released versions use this format:

```text
MAJOR.MINOR.PATCH
```

Git tags and GitHub releases use the same plain version, without a leading `v`:

```text
MAJOR.MINOR.PATCH
```

Examples:

- `0.1.0` in documentation and changelog headings
- `0.1.0` as the Git tag and GitHub release name
- `0.2.0-beta.1` for an optional pre-release

## Semantic Versioning Rules

Use these rules once the package has a stable `1.0.0` release:

- Increment `MAJOR` for breaking public API changes.
- Increment `MINOR` for backward-compatible features.
- Increment `PATCH` for backward-compatible fixes and documentation corrections that support an already released version.

Before `1.0.0`, ACLogging is in initial development:

- `0.MINOR.0` may introduce public API changes.
- `0.MINOR.PATCH` should remain backward-compatible within that minor line.
- Breaking changes must be called out clearly in `CHANGELOG.md`.

## Public API Surface

Versioning decisions are based on the public products and public symbols exposed by the package:

- `ACLogging`
- `ACLoggingOSLog`
- `ACLoggingSwiftUI`
- `ACLoggingTestSupport`

Examples of breaking changes:

- Renaming or removing a public type, method, property, enum case, product, or target.
- Changing a public method signature.
- Changing default behavior in a way that can alter existing client app behavior.
- Raising minimum supported platform versions.

Examples of non-breaking changes:

- Adding a new public type or method with no source break.
- Adding a new adapter product.
- Improving documentation.
- Adding tests.
- Fixing adapter behavior while preserving public signatures.

## Changelog Rules

Keep `CHANGELOG.md` as the release history.

The top section must always be:

```markdown
## Unreleased
```

When cutting a release, move relevant entries from `Unreleased` into a dated version section:

```markdown
## 0.1.0 - 2026-05-03
```

Use these entry groups when helpful:

- `Added`
- `Changed`
- `Fixed`
- `Removed`
- `Deprecated`
- `Breaking`

Every released version must have:

- A matching changelog section.
- A matching Git tag, for example `0.1.0`.
- A matching GitHub release, if the repository has a remote.

## Release Flow

Local branch flow:

1. Merge feature work into `develop`.
2. Verify from `develop` with `swift test`.
3. Update `CHANGELOG.md` by moving completed entries from `Unreleased` into the release section.
4. Merge `develop` into `main`.
5. Create an annotated tag from `main`:

```bash
git tag -a 0.1.0 -m "Release 0.1.0"
```

6. Push `main`, `develop`, and the tag when a remote is configured.

Remote branch flow:

1. Open a pull request from the feature branch to `develop`.
2. After merge and verification, open a pull request from `develop` to `main`.
3. Create the GitHub release from the tag on `main`.

## Documentation References

Documentation should refer to stable releases by version number and tag.

Every DocC page must explicitly state which code version it documents. Before a public release tag exists, the page should say it describes the unreleased API planned for the next release, for example `0.1.0`. After a release is tagged, published DocC must be generated from the matching Git tag and identify that release version.

Examples:

- Installation examples can use `from: "0.1.0"` once the `0.1.0` tag exists.
- Migration notes should name the source and target versions, for example `0.1.x to 0.2.0`.
- Adapter documentation should state when an adapter was introduced if that matters to package clients.

## Roadmap Integration

When `ROADMAP.md` is created, it should use planned milestone versions without pretending they are released.

Recommended sections:

```markdown
## 0.2.0 - Planned
## 0.3.0 - Planned
## 1.0.0 - Planned Stable API
```

The roadmap should describe intent and priority. `CHANGELOG.md` remains the source of truth for released changes.
