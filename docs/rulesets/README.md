# Repository rulesets

GitHub stores rulesets in repository settings, not in Git. The JSON here is the
source of truth: edit it here, then re-import it. The layout follows
[justinharringa/capivara-rica](https://github.com/justinharringa/capivara-rica/tree/main/docs/rulesets)
and [justinharringa/knuckles](https://github.com/justinharringa/knuckles/tree/main/docs/rulesets).

## `main.json`: nothing reaches the live site without a build

A push to `main` deploys to www.harringa.com within minutes, with no approval
step (`.github/workflows/main.yml`). So the ruleset is the only gate in front of
production.

| Rule | Why |
|---|---|
| Require a pull request, 0 approvals | Nothing lands on `main` without the PR build running. With one maintainer, a required approval could never be satisfied. |
| Require status check `build` | The `build` job in `pr.yml` ("PR Build Check"). It has no path filter, so it always reports and cannot leave a PR blocked forever. |
| **Not** "require branches to be up to date" | It makes every push to `main` rebase every open Renovate PR and re-run its build. |
| Block force-push and deletion | `main` is what gets deployed. |
| Bypass: repository admin, **pull requests only** | Break-glass. The owner can merge a PR while the build is broken, but still cannot push to `main` directly. |

### The check name is shared

`main.yml` also has a job named `build`, which runs on pushes to `main`. A
required check is matched by name, so that run reports a `build` as well. It only
ever runs on `main`, after a merge, so it cannot satisfy or block a PR. If this
ever becomes confusing, rename the PR job (for example `pr-build`) in `pr.yml`
and change `context` here in the same PR.

### Known gaps

- The PR build never exercises the deploy job, the AWS secrets or the
  `s3_website` image, so a green PR can still fail to deploy.
- A GitHub-side scheduling stall shows up as a missing check, not a red one. A
  run with `total_count: 0` jobs carries no information about the code:
  `gh api repos/justinharringa/harringa.com/actions/runs/<id>/jobs --jq .total_count`.
- Two PRs can each pass against an older `main` and conflict once both merge.

## Applying it

Order matters: if the ruleset is imported before `build` has ever reported on a
PR, every open PR blocks. `build` last reported on PR #64, so it is safe today.

1. **Settings → Rules → Rulesets → New ruleset → Import a ruleset**, choose
   `docs/rulesets/main.json`. Or:

   ```bash
   gh api -X POST repos/justinharringa/harringa.com/rulesets --input docs/rulesets/main.json
   # later: gh api -X PUT repos/justinharringa/harringa.com/rulesets/<id> --input docs/rulesets/main.json
   ```

2. Check the imported status check is bound to the GitHub Actions app
   (`integration_id` 15368).
3. Open a trivial PR and confirm it cannot merge until `build` passes.
4. Confirm: `gh api repos/justinharringa/harringa.com/rulesets --jq '.[].name'`
   lists `main`.
