# Daily Update Workflow

Files:
- `.github/workflows/daily-update.yml` — the workflow
- `scripts/update.sh` — your update logic (edit this)

## What it does
Daily at **02:30 UTC (08:00 IST)**:
1. Checks out `main`, recreates branch `automated/daily-update` from it.
2. Runs `./scripts/update.sh`.
3. If nothing changed → exits cleanly, no PR.
4. If changed → commits, force-pushes (with `--force-with-lease`), opens a PR
   (or updates the existing one), then squash-merges it and deletes the branch.

## One-time repo setup
**Settings → Actions → General → Workflow permissions:**
- Select **Read and write permissions**
- Check **Allow GitHub Actions to create and approve pull requests**

**Settings → General:** enable **Allow auto-merge** (needed only if `main` has
branch protection with required status checks).

## Customising
| Change | Where |
| --- | --- |
| Schedule | `on.schedule.cron` (always UTC) |
| Branch names | `env.BASE_BRANCH`, `env.UPDATE_BRANCH` |
| Script path | `env.UPDATE_SCRIPT` |
| Merge style | `--squash` → `--merge` / `--rebase` |
| Runtimes | uncomment the `setup-node`/`setup-python` step |

Run it on demand from the Actions tab ("Run workflow"); tick **dry_run** to
execute the script without opening or merging a PR.

## Important caveat: GITHUB_TOKEN and other workflows
Commits and PRs made with the default `GITHUB_TOKEN` **do not trigger other
workflows** (GitHub blocks this to prevent recursion). So your CI checks will
NOT run on this PR. If you need them to:
1. Create a PAT (repo scope) or GitHub App token, save as secret `BOT_TOKEN`.
2. In the checkout step use `token: ${{ secrets.BOT_TOKEN }}`.
3. Set `GH_TOKEN: ${{ secrets.BOT_TOKEN }}` in the PR and merge steps.

Note this interacts with branch protection: if checks are required but never
run (default token), the immediate merge fails and the workflow falls back to
auto-merge, leaving the PR open until checks report. Use a PAT in that case.

## Verified
`actionlint` 1.7.12 + `shellcheck` 0.10.0: clean. Git/PR/merge sequence was
dry-run end-to-end against a local remote with a stubbed `gh`.
 
