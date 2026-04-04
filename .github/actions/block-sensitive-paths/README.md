# block-sensitive-paths

A reusable GitHub Actions composite action that **rejects pull requests** containing
files in private/internal directories that must not appear in public repositories.

## Features

- Configurable list of blocked path patterns (directory prefixes and exact filenames)
- Runs on PR events; fails the check with a clear message listing each blocked file
- Handles large PRs via paginated GitHub API calls
- Emits per-file `::error::` annotations so violations are highlighted in the PR diff
- Zero external dependencies — pure bash + `gh` CLI (available on all GitHub-hosted runners)

## Usage

### In this repository (self-referencing)

```yaml
- uses: ./.github/actions/block-sensitive-paths
  with:
    blocked-paths: |
      .ai/
      docs/plans/
      artifacts/
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

### From another CascadeGuard repository

```yaml
- uses: cascadeguard/cascadeguard-open-secure-images/.github/actions/block-sensitive-paths@main
  with:
    blocked-paths: |
      .ai/
      docs/plans/
      artifacts/
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Minimal example (uses default blocked paths)

```yaml
name: PR Path Guard
on:
  pull_request:
    branches: [main]
    types: [opened, synchronize, reopened]

permissions:
  contents: read
  pull-requests: read

jobs:
  block-sensitive-paths:
    runs-on: ubuntu-latest
    steps:
      - uses: cascadeguard/cascadeguard-open-secure-images/.github/actions/block-sensitive-paths@main
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `blocked-paths` | No | `.ai/`<br>`docs/plans/`<br>`artifacts/` | Newline-separated path prefixes to block. Trailing `/` = directory prefix match. |
| `github-token` | No | `github.token` | GitHub token for listing PR files via the REST API. |

## Path pattern matching

| Pattern | Matches |
|---------|---------|
| `.ai/` | Any file whose path starts with `.ai/` (e.g. `.ai/agents/foo.md`) |
| `docs/plans/` | Any file whose path starts with `docs/plans/` |
| `AGENTS.md` | Only the file named exactly `AGENTS.md` at the repo root |

## Adding as a required status check

1. Add the workflow to your repository.
2. In **Settings → Branches → Branch protection rules** for `main`, enable
   **Require status checks to pass** and add `block-sensitive-paths` (the job name).
3. PRs that touch restricted paths will be blocked from merging until the files are removed.

## Error output example

When a violation is detected the action prints:

```
Blocked files detected:
  ✗ .ai/agents/config.yaml (matched directory: '.ai/')
  ✗ docs/plans/roadmap.md (matched directory: 'docs/plans/')

The following path patterns are restricted in this repository:
  • .ai/
  • docs/plans/
  • artifacts/

Please remove these files from your pull request before re-requesting review.
```

It also emits `::error::` annotations so violations appear inline on the PR **Files changed** tab.
