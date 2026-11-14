---
name: renovate-triage
description: Triage harringa.com's open Renovate PRs from evidence, not titles. A merge to main deploys to www.harringa.com (S3 + CloudFront) within minutes with no approval step, so classify each PR by what it can change in production, read the upstream notes, require the PR's `build` check green on the current head (nothing on GitHub is known to enforce it), merge one PR at a time, and verify the Deploy Site run and the live site after each merge. Works unattended from a cloud session (GitHub connector or `gh api`). Use when asked to triage, review or clear harringa.com's Renovate PRs or its Dependency Dashboard, or when the Daily Renovate Triage routine reaches this repo.
---

# Renovate Triage: harringa.com

A personal Hugo site (`config.yaml`, `content/`, theme `bota` as a git
submodule at `themes/bota`). Read `.github/renovate.json` once before the first
triage. It is short: `config:recommended`, the Dependency Dashboard, and one
regex manager that reads `# renovate:` comments in the two workflows.

**Here a merge is a deploy.** There is no approval step, unlike capivara-rica.

```
PR merged to main ──▶ Deploy Site (main.yml): build with Hugo ──▶ s3_website
   push to the www.harringa.com bucket ──▶ CloudFront invalidation ──▶ live
```

- A failed deploy leaves the previous site live. A deploy that succeeds but
  ships a broken site is the case to catch, and only Phase 4 catches it.
- `concurrency: pages` with `cancel-in-progress: false` queues deploys, so two
  merges in a row both deploy, one after the other.
- **Triage never rolls back, re-runs or dispatches a workflow.** Rolling back is
  the owner's: revert PR, or `workflow_dispatch` on `main.yml`. Triage notifies.

## What each dependency can change

| Dependency | Where | Can it change what visitors get? |
|---|---|---|
| **Hugo** (`HUGO_VERSION`, `gohugoio/hugo`) | `main.yml` and `pr.yml`, same line in both | **yes**: it renders the site. Minors have removed deprecated template functions and config keys before, and changed output |
| **GitHub Actions** (`checkout`, `upload-artifact`, `download-artifact`; floating majors) | both workflows | no, unless a major changes artifact or submodule behaviour. Only majors arrive, so every action PR is Ask first |
| **`justinharringa/s3_website` image** (`# renovate: datasource=docker`, pinned by digest) | `main.yml` deploy job only | **the deploy itself**: it holds the AWS credentials and does the S3 push and CloudFront invalidation |
| Dart Sass (`snap install dart-sass`), `gh` and Ubuntu runner image | not pinned | not Renovate's. A red PR build from these is not the PR's fault |
| Theme submodule `themes/bota` | `.gitmodules` | not tracked by this Renovate config. A PR bumping it is Ask first |

## What gates a PR, and what does not

`pr.yml` ("PR Build Check", job `build`) runs on every PR to `main`: it installs
the Hugo version **in the PR's own `pr.yml`**, then `hugo --destination ./public
--printPathWarnings`. It never deploys and never touches AWS.

- A Hugo bump edits both workflows to the same version, so the PR build does
  exercise the new Hugo. That makes it meaningful for Hugo. Read the log for
  `WARN` and `ERROR` lines as well as the conclusion: a deprecation warning that
  turns into a removal in the next minor is worth a line in the report.
- It says nothing about the **deploy job**: the s3_website image, the AWS
  secrets, the bucket and CloudFront. Those first run on the merge.
- As of 2026-11-14 `main` had no branch protection and no ruleset (the REST API
  returned 404 and `[]`). `docs/rulesets/main.json` proposes one that requires
  `build`. Until it is imported, **nothing enforces `build`**, so triage checks
  it itself; afterwards triage still checks it, because the owner can bypass.
- The check's name is `build` (seen on PR #64). `main.yml` has a job of the
  same name that runs only on pushes, so a `build` on a `main` commit is the
  deploy workflow's, not a PR check.

## Phase 0: Inventory

```bash
R=justinharringa/harringa.com
gh api "repos/$R/pulls?state=open&per_page=50" \
  --jq '.[] | "#\(.number) \(.user.login) [\([.labels[].name]|join(","))] \(.head.sha[0:7]) \(.title)"'
```

In a routine use the connector's `list_pull_requests`. The Dependency Dashboard
is the open issue titled `Dependency Dashboard` by `renovate[bot]`; find it by
title. Do not filter on the `renovate` label: security PRs carry `security`.
A PR from `dependabot[bot]` means Dependabot security updates were switched on;
report it rather than triaging around it.

## Phase 1: Classify

| Bucket | Recognise by | Triage does |
|---|---|---|
| **Ask first** | any GitHub Actions PR (all are majors); any change to the `s3_website` digest; a Hugo **major** (`0.x` → `1.0`) ; any PR touching `config.yaml`, `content/`, `themes/`, `static/`, `build/` or `s3_website.yml`; a Renovate config-migration PR (`renovate.json` edits); a `security` PR that is not a plain Hugo bump | Gather the evidence (Phase 2), then notify. Do not merge |
| **Candidate LOW RISK** | **Hugo** `0.x.y` minor or patch, with both workflows changed to the same version and nothing else | Apply the rubric |

Hugo is pre-1.0, so a minor can carry breaking changes. That is why the rubric
below is not "merge every Hugo PR".

## Phase 2: Read the notes

1. The PR body (Renovate attaches Hugo's GitHub release notes).
2. If it has none: anonymous
   `curl -s https://api.github.com/repos/gohugoio/hugo/releases/tags/v<version>`
   (a 403 is the per-IP rate limit, so move on); WebFetch of
   `https://github.com/gohugoio/hugo/releases/tag/v<version>`; `gh api` for the
   same path. In a routine the GitHub connector refuses repos outside the
   session, so it cannot read upstream notes. **"Notes not read" is not an
   outcome:** if every route fails, report "notes unreachable" with each route
   tried.
3. Look for: **removed** or renamed template functions, config keys, taxonomy or
   permalink behaviour, changes to Sass or asset pipelines (the theme needs the
   extended build), and anything about `--printPathWarnings`. Then check whether
   the repo or the theme uses the thing:

   ```bash
   grep -rn '<symbol>' config.yaml content layouts themes/bota 2>/dev/null
   ```

   The theme is a submodule, so grep it only if `themes/bota` is checked out.
   If it is not, say so in the report instead of treating the grep as clean.

## Phase 3: LOW RISK rubric

Merge only if **every** line holds. Otherwise hold or ask, and name the line
that failed.

- [ ] Bucket is *Candidate LOW RISK*
- [ ] Notes read (Phase 2), with nothing removed or breaking that this site uses
- [ ] The PR's `build` check is **SUCCESS on the current head SHA**, and its log
      has no new `ERROR`. Pending is not success
- [ ] Files touched are only the `HUGO_VERSION` line in `main.yml` and `pr.yml`,
      the same new value in both, and match the title
- [ ] One commit, authored by Renovate; no hand edits on the branch
- [ ] `main`'s latest `Deploy Site` run is green, so a merge cannot hide an
      existing breakage
- [ ] No other merge in this repo is still unverified. Each merge is its own
      production deploy, so verify one before the next

Merge with a merge commit, matching the history (#63, #64):

```bash
gh api -X PUT repos/$R/pulls/<n>/merge -f merge_method=merge -f sha=<head-you-reviewed>
```

In a routine, the connector's `merge_pull_request` with `merge_method: "merge"`
and `expectedHeadSha: <head you reviewed>`.

## Phase 4: Verify production (a few minutes after each merge)

1. **The deploy ran.** `actions_list` method `list_workflow_runs` for
   `main.yml`, branch `main`, event `push`. Match the run's `head_sha` to the
   merge commit (a green run on an older commit proves nothing), and require
   `completed` / `success` with **both** the `build` and `deploy` jobs
   successful (`list_workflow_jobs`). A run still `queued` or `in_progress` is
   not a pass.
2. **The live site is up and was rebuilt:**

   ```bash
   curl -sSI https://www.harringa.com/ | head -5      # expect HTTP 200
   curl -sS --compressed https://www.harringa.com/ | grep -o -i '<meta name="generator"[^>]*>'
   ```

   The page carries `<meta name="generator" content="Hugo X.Y.Z">`, which
   should name the merged version. **Use `--compressed`**: the page is served
   gzipped, and without it grep sees nothing. CloudFront can serve the old page
   for a minute or two after the invalidation, so recheck once before calling it
   stale.
3. **If the host cannot be reached** from the session (the egress proxy can
   refuse hosts), say so in the report. The deploy run is then the only
   evidence, and the report must not claim the site was checked.

A failed deploy, or a live site that is down or broken after a merge, is the one
urgent notification this skill sends. Stop merging, and notify at once with the
PR, the merge SHA, the failing job and its output, and the rollback route above.
Do not fix forward from triage.

## Unattended (routine) mode

The Daily Renovate Triage routine runs this skill with nobody watching, from the
parent of the repo clones, so this file is not auto-loaded; the routine prompt
points here. It has the GitHub connector and `gh api` (REST only: `gh`
porcelain fails with `GraphQL is not available from Claude Code sessions`).

**May do:** read anything; merge PRs that pass every line of Phase 3, one at a
time, with Phase 4 after each.

**Never:**
- push tags or commits, dispatch or re-run workflows, or comment on, close or
  edit PRs
- touch AWS or CloudFront
- tick Dependency Dashboard boxes (never "rebase all")
- merge anything Ask first, or anything whose `build` is red or pending. Never
  merge on the reasoning "the failure is unrelated"

**Notify (one line per item, inside the routine's single notification), only
when:**
1. **The site failed Phase 4 after a merge.** Always, first in the message.
2. A PR needs the owner: Ask first, or held because its own change broke
   `build`. Notify on the day it is opened or its head changes (`updated_at`
   within 24h). A PR that is merely still held stays out of the notification.
3. A Dependabot PR appeared.

Merged PRs that passed Phase 4 are silent; record them in the report. Message
shape: `harringa.com: <action needed> — #<n> <title>: <one-line evidence>`.

## Known false alarms

| Observation | Why it's fine |
|---|---|
| `snap install dart-sass` fails or is slow on the runner | Network or runner flake, not the PR. It is unpinned, so say so and hold the PR rather than merging on red |
| Dashboard lists updates under *Pending Status Checks* | Waiting on Renovate, not a PR yet |
| A deploy run is `queued` right after a merge | `concurrency: pages` queues behind an earlier deploy |

## Report

For each PR: number, title, bucket, decision (merged / held / ask), and one or
two lines of evidence. For each merge: the merge SHA, the `Deploy Site` run id
and both job conclusions, and what the live-site check showed (or that it could
not run).

## Known characteristics

- **2026-11-14, skill drafted** with no PRs open. Renovate's Hugo bumps #63, #64
  and #65 were merged by the owner with merge commits. Verified: `main` was
  unprotected, the PR check is `build`, www.harringa.com is reachable from the
  routine's network once `*.harringa.com` is on the allow list, and the generator
  tag works: after #65 (Hugo 0.170.0) merged at 06:30Z, `Deploy Site` finished at
  06:31Z and the live page named `Hugo 0.170.0`, with `Last-Modified` 06:31:23Z.
