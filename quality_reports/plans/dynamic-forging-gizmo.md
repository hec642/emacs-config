# Plan — Orchestrator + Editor + Publisher agents for `emacs-init`

## Context

`~/claude-projects/emacs-init/` is the user's personal Emacs configuration, mirrored to the public GitHub repo `git@github.com:your-github-user/emacs-config.git`. It has minimal Claude Code scaffolding today (only `.claude/settings.local.json`) and no agent system. The user wants a small, mutually-exclusive two-agent workflow — an **editor** that may read and refine files but never publishes, and a **publisher** that may commit and push but never edits — with a CLAUDE.md orchestrator routing between them. Every push must be PII-clean (no real names, emails, addresses, phone numbers, GitHub usernames, or absolute home paths) and the workflow itself must be able to learn and tighten over successive iterations of the project.

The pattern follows the sister projects (`surgery-writing-assistant`, `surgical-lecture-assistant`, `academic-workflow`) so the design feels native to this workspace.

## Design summary

```
user request
    │
    ▼
CLAUDE.md (orchestrator — routing table + cascade rules)
    │
    ├── @editor   ─→ scans, refines, redacts PII to placeholders
    │                writes editor-handoff.md → publisher
    │
    └── @publisher ─→ reads handoff, stages, re-greps for PII,
                      commits, PAUSES for human approval, pushes
```

- Orchestrator is `CLAUDE.md` (sister-project pattern); no separate orchestrator agent.
- Editor and publisher have **disjoint** tool sets — editor cannot run git, publisher cannot edit files.
- Publisher always commits but **stops before `git push`** and asks the user to approve.
- A small `.claude/state/run-log.md` (gitignored) preserves "process memory" across sessions; a tracked `.claude/PII-PATTERNS.md` is the single source of PII regex truth so both agents stay in sync.
- After each successful publish, the orchestrator appends a one-line lesson to `.claude/state/learnings.md` (gitignored). When ≥3 unaddressed lessons accumulate, the orchestrator suggests editing the agent `.md` files — this is the "improve workflow with iterations" loop.

## Files to create / modify

### Create

| Path | Tracked? | Purpose |
|------|----------|---------|
| `CLAUDE.md` | yes | Orchestrator — routing table, cascade, PII rules, iteration loop instructions |
| `.claude/agents/editor.md` | yes | Editor agent — `tools: Read, Edit, Grep, Glob`. No Bash, no Write outside repo files. |
| `.claude/agents/publisher.md` | yes | Publisher agent — `tools: Read, Bash, Grep, Glob`. No Edit, no Write. |
| `.claude/PII-PATTERNS.md` | yes | Single source of PII regexes (real name, email, GitHub user, abs home path, hospital names, phone, ZIP). |
| `.claude/state/run-log.md` | **no** (gitignore) | Append-only memory of every editor + publisher run |
| `.claude/state/learnings.md` | **no** (gitignore) | One-line lessons from friction points; drives iteration |

### Modify

| Path | Change |
|------|--------|
| `.gitignore` | Add `.claude/settings.local.json`, `.claude/state/` |
| `README.md:41` | clone URL — replace real GitHub username with `your-github-user` (only real-PII hit found in tracked files) |

### Pending git changes already on disk (separate concern, surface to user)

The working tree currently has chmod 100644 → 100755 on every tracked `.el`/`.md`/`LICENSE`/`.gitignore`. These look accidental. The publisher will surface them and ask whether to revert (`git update-index --chmod=-x`) or keep before its first commit.

## Agent contracts

### `@editor` — `editor.md`

- **Tools:** `Read, Edit, Grep, Glob`
- **Inputs:** user request + a list of files to publish (defaults to `git diff --name-only origin/main...HEAD` ∪ untracked).
- **Steps:**
  1. Read `.claude/PII-PATTERNS.md`.
  2. Grep every candidate file for each pattern.
  3. For each hit, replace with the documented placeholder (`Your Name`, `your-email@example.com`, `your-github-user`, `~/...`).
  4. If a hit has ambiguous semantics (e.g., a path that's actually load-bearing), STOP and surface to user — do not guess.
  5. Apply any prose/clarity fixes the user explicitly requested.
  6. Write `.claude/state/editor-handoff.md` containing: file list, redactions applied, residual concerns, "ready for publisher: yes/no".
  7. Append a dated entry to `.claude/state/run-log.md`.
- **Forbidden:** `Bash`, `Write` to `.git/`, any commit/push verbs.

### `@publisher` — `publisher.md`

- **Tools:** `Read, Bash, Grep, Glob`
- **Inputs:** `.claude/state/editor-handoff.md` (must exist and say `ready: yes`).
- **Steps:**
  1. Refuse if no handoff or `ready: no`.
  2. Run final PII grep on `git diff --staged` and on untracked-to-be-added files (defense in depth — editor scan can drift).
  3. Stage the files listed in handoff (named explicitly, not `git add -A`).
  4. Generate commit message from handoff summary.
  5. Run `git commit`.
  6. Print the new SHA + `git log --oneline -1` + `git diff origin/main..HEAD --stat` and **STOP**. Ask user to approve `git push`.
  7. On approval, push, then append outcome to `.claude/state/run-log.md`.
- **Forbidden:** `Edit`, `Write` to any file except `.claude/state/run-log.md` (append-only via `Bash >>`); never edits source files even to "fix one small thing" — must bounce back to editor.

### `CLAUDE.md` (orchestrator) — key sections

- 1-paragraph project description.
- Routing table: `@editor` → `.claude/agents/editor.md`; `@publisher` → `.claude/agents/publisher.md`.
- Cascade: `@editor → @publisher` (only one cascade — keep it simple).
- Hard rule: never invoke publisher without an editor handoff in the same session.
- Iteration loop: after each successful publish, prompt "anything to record in learnings?" → if user gives feedback, append to `.claude/state/learnings.md`. When that file has ≥3 unaddressed lines, flag the user to update agent .md files.

## Verification

1. **Dry-run editor on current state.** Invoke `@editor` over the current working tree. Expected: it flags `README.md:41` for GitHub-username redaction, applies it, writes a handoff. Inspect handoff file.
2. **Dry-run publisher.** Invoke `@publisher`. Expected: re-grep is clean, files staged, commit created, **execution stops** before `git push`, SHA + diff stat printed.
3. **Negative test — editor isolation.** Ask `@editor` to "push to GitHub". Expected: refuses (no Bash tool).
4. **Negative test — publisher isolation.** Ask `@publisher` to "fix the README typo while you're at it". Expected: refuses (no Edit tool); says to re-run `@editor` first.
5. **Memory persistence.** Open `.claude/state/run-log.md` after both runs — expected: dated entries from each agent.
6. **Approve push and confirm remote.** After approval, `git -C ~/claude-projects/emacs-init log origin/main..HEAD` should be empty (everything pushed); `gh repo view your-github-user/emacs-config --json updatedAt` should show fresh timestamp.
7. **Iteration loop sanity.** Manually add 3 lines to `learnings.md`; start a new session and request a publish — expected: orchestrator surfaces those lessons and suggests revising agent .md files before proceeding.

## Out of scope

- No CI/hooks integration (e.g., pre-commit). Possible future iteration if `learnings.md` shows the same PII pattern repeatedly slipping past.
- No multi-branch workflow. Single `main` branch only, matching current repo state.
- No automated detection of accidental `chmod` changes — surfaced to user, not auto-reverted.
