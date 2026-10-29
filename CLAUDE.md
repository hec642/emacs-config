# CLAUDE.md — emacs-init

Personal GNU Emacs configuration. Mirrored to public GitHub. Every push must be PII-clean.

## Agents (mutually exclusive)

| Trigger | Routes to | Allowed | Forbidden |
|---------|-----------|---------|-----------|
| `@editor`, "edit", "redact", "scan for PII", "prepare to publish" | `.claude/agents/editor.md` | Read, Edit, Grep, Glob | Bash, git, push |
| `@publisher`, "publish", "commit and push", "ship it" | `.claude/agents/publisher.md` | Read, Bash, Grep, Glob | Edit, Write, push |

## Cascade

```
@editor → @publisher (commit) → orchestrator (push, after user approval)
```

Hard rules:
- **Never invoke `@publisher` without an `@editor` handoff in the same chain.** The publisher will refuse if the handoff is missing or stale.
- **Editor never commits or pushes.** If the user asks the editor to "just push it", route to `@publisher` after the handoff is written.
- **Publisher never edits.** If the publisher finds a problem in source, it bounces back to `@editor`.
- **Publisher never pushes; the orchestrator does.** Subagents can't accept an approval relayed to them, so the push happens in the main session, where the user types the approval directly.

## Push (orchestrator)

After the publisher reports `Commit ready for orchestrator push`:
1. Show the user the SHA, the commit message and the diffstat, then ask: "Approve `git push origin main`?"
2. Push only on the user's own clear yes in this session. Before pushing, check that `git rev-parse HEAD` still matches the SHA the publisher reported. If it doesn't, ask again.
3. Run `git push origin main`. If it fails with `Permission denied (publickey)` and `gh auth status` succeeds, switch origin to HTTPS (`git remote set-url origin https://github.com/<owner>/<repo>.git`), run `gh auth setup-git`, and retry.
4. Append `YYYY-MM-DD HH:MM  orchestrator  <sha>  pushed=<yes|no>` to `.claude/state/run-log.md` and report the GitHub commit URL.

## PII rules

- The single source of truth is `.claude/PII-PATTERNS.md`. Both agents read it; nobody hardcodes patterns elsewhere.
- Allowed placeholders: `Your Name`, `your-email@example.com`, `your-github-user`, `Your Institution`, `~/...`.
- Files that are gitignored (`.env`, `secrets.el`, `private.el`, `local.el`, `.claude/settings.local.json`, `.claude/state/`) are never published — don't redact them.

## Process memory

- `.claude/state/run-log.md` (gitignored) — append-only audit trail of every editor + publisher run.
- `.claude/state/editor-handoff.md` (gitignored) — the contract the editor writes for the publisher; overwritten each editor run.
- `.claude/state/learnings.md` (gitignored) — one-line lessons captured after a publish.

## Iteration loop

After a successful push, ask the user:
> Anything to record about this run? (friction, missed PII pattern, awkward step)

If yes, append a one-line dated entry to `.claude/state/learnings.md`. When that file accumulates **≥3 unaddressed lines**, surface them at the start of the next session and propose concrete edits to:
- `.claude/PII-PATTERNS.md` (new patterns / placeholders)
- `.claude/agents/editor.md` or `.claude/agents/publisher.md` (workflow changes)
- this CLAUDE.md (routing or cascade changes)

Then mark those lines `[addressed]` rather than deleting them — preserves the audit trail.

## File map

| Path | Tracked? | Role |
|------|----------|------|
| `CLAUDE.md` | yes | this file — orchestrator |
| `config.org` | yes | literate source; tangles to `config.el` (edit here, not the `.el`) |
| `early-init.org` | yes | literate source; tangles to `early-init.el` |
| `config.el`, `early-init.el` | yes | tangled output; publish together with their `.org`, and re-tangle to verify after any src-block redaction |
| `.claude/agents/editor.md` | yes | editor agent definition |
| `.claude/agents/publisher.md` | yes | publisher agent definition |
| `.claude/PII-PATTERNS.md` | yes | PII patterns + placeholders |
| `.claude/settings.local.json` | no | machine-local Claude permissions |
| `.claude/state/` | no | run-log, handoff, learnings |
| `quality_reports/plans/` | yes | implementation plans for this workflow |

## Quick start

- "Publish my recent changes" → orchestrator invokes `@editor` first; on `ready: yes`, invokes `@publisher` to commit; the orchestrator then asks the user to approve and pushes.
- "Just scan for PII" → `@editor` only.
- "I already cleaned the files; push them" → `@publisher` will still demand a handoff. Run `@editor` first (it's idempotent and fast on clean files).

Note: After editing or adding files in `.claude/agents/`, restart your Claude Code session before invoking the new agent.
