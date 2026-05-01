# PII Patterns — single source of truth

Both `@editor` and `@publisher` reference this file. Keep regex-style patterns
in column 1 and the canonical placeholder in column 2. Don't duplicate the
list anywhere else — extend this table instead.

| Pattern (case-insensitive grep) | Placeholder | Notes |
|---------------------------------|-------------|-------|
| `hec642` | `your-github-user` | GitHub username — appears in clone URLs |
| `hdepaz`, `hdepaz90` | `your-github-user` | Alt usernames / email locals |
| `/home/hec(/\|$)` | `~/` or `$HOME/` | Absolute home paths leak username |
| `\bhec\b` (as a path/user component, not in words like "checkbox") | `you` | Username in standalone form |
| `[A-Za-z0-9._%+-]+@(?!example\.com\b)[A-Za-z0-9.-]+\.[A-Za-z]{2,}` | `your-email@example.com` | Any real email; `*@example.com` is allowed as placeholder |
| `Wyckoff`, `Wyckoff Heights`, `WHMC` | `Your Institution` | Hospital/institution name |
| `\b\d{3}[-. ]\d{3}[-. ]\d{4}\b` | `555-555-5555` | US phone |
| `\b\d{5}(-\d{4})?\b` (in address contexts) | `00000` | ZIP code — review hits manually, may be false-positive in code |
| Real first/last name strings in `user-full-name`, `\author{}`, `#+AUTHOR:` | `Your Name` | Already placeholder in current files — verify no regression |
| Hardcoded street addresses | `123 Example St` | None known currently |

## Allowed (do NOT redact)

- `your-email@example.com`, `Your Name`, `Your Institution`, `your-github-user` — these are the placeholders themselves.
- `git@github.com` (the SSH host) — not PII; only the username after `:` matters.
- `(user-login-name)`, `(system-name)` — Elisp expressions that resolve at runtime; safe.
- Strings inside `.gitignore`'d files (`.env`, `secrets.el`, `private.el`, `local.el`, `.claude/settings.local.json`, `.claude/state/`) — never published.

## When a hit is ambiguous

The editor must STOP and ask the user. Do not guess. Examples:
- A path like `/home/hec/some-shared-asset` that may be load-bearing.
- A hospital name that is part of a citation rather than authorship.
