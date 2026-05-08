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

- `1.0.1` in documentation and changelog headings
- `1.0.1` as the Git tag and GitHub release name
- `1.1.0-beta.1` for an optional pre-release

## Semantic Versioning Rules

Use these rules for the stable public package line:

- Increment `MAJOR` for breaking public API changes.
- Increment `MINOR` for backward-compatible features.
- Increment `PATCH` for backward-compatible fixes and documentation corrections that support an already released version.

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
## 1.0.1 - 2026-05-08
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
- A matching Git tag, for example `1.0.1`.
- A matching GitHub release, if the repository has a remote.

## Release Flow

Local branch flow:

1. Merge feature work into `develop`.
2. Verify from `develop` with `swift test`.
3. Update `CHANGELOG.md` by moving completed entries from `Unreleased` into the release section.
4. Merge `develop` into `main`.
5. Create an annotated tag from `main`:

```bash
git tag -a 1.0.1 -m "Release 1.0.1"
```

6. Push `main`, `develop`, and the tag when a remote is configured.

Remote branch flow:

1. Open a pull request from the feature branch to `develop`.
2. After merge and verification, open a pull request from `develop` to `main`.
3. Create the GitHub release from the tag on `main`.

## Documentation References

Documentation should refer to stable releases by version number and tag.

Every DocC page must explicitly state which code version it documents. Published DocC must be generated from the matching Git tag and identify that release version.

Examples:

- Installation examples can use `from: "1.0.1"` once the `1.0.1` tag exists.
- Migration notes should name the source and target versions, for example `1.0.x to 1.1.0`.
- Adapter documentation should state when an adapter was introduced if that matters to package clients.

## Roadmap Integration

When `ROADMAP.md` is created, it should use planned milestone versions without pretending they are released.

Recommended sections:

```markdown
## 1.1.0 - Planned
## 1.2.0 - Planned
## 2.0.0 - Planned Major API Review
```

The roadmap should describe intent and priority. `CHANGELOG.md` remains the source of truth for released changes.
