# emacs-config

Personal GNU Emacs configuration, org-mode centric, built on
[`straight.el`](https://github.com/radian-software/straight.el) and
[`use-package`](https://github.com/jwiegley/use-package).

## Features

- **Knowledge management** — `org-mode`, `org-roam`, `org-roam-ui`,
  `citar`/`bibtex` + `org-cite`, Anki integration.
- **Document authoring** — custom LaTeX classes (article, book, Beamer),
  `ox-reveal` for Reveal.js, Quarto, Markdown, Graphviz, `org-babel`
  (Elisp, LaTeX, CSS, ...).
- **AI assistants** — `gptel`, GitHub Copilot,
  [`claude-code-ide`](https://github.com/manzaltu/claude-code-ide.el),
  multiple MCP servers (filesystem, GitHub, Graphlit, Qdrant).
- **Editing** — `evil`, `vertico`, `corfu`, `cape`, PDF Tools, Magit.
- **Terminals & files** — `vterm`, `eshell` with a custom prompt, `dired`
  with extensions.
- **UI** — Modus themes, JetBrains Mono, `nerd-icons`, variable-pitch
  prose, per-mode cursor colors.
- **Performance** — native compilation, GC tuning, deferred file-handler
  alist, session persistence (`desktop`, `recentf`).

## Files

| File | Purpose |
|------|---------|
| `early-init.el` | Runs before package init — GC, frame defaults, native-comp. |
| `init.el` | Entry point; loads `config.org` (or `config.el`). |
| `config.el` | Main configuration (all `use-package` declarations). |
| `custom.el` | Values written by Emacs's Customize interface. |

## Install

```sh
# Back up anything you already have
mv ~/.emacs.d ~/.emacs.d.bak 2>/dev/null

# Clone
git clone git@github.com:hec642/emacs-config.git ~/.emacs.d

# Start Emacs — straight.el will bootstrap itself and pull all packages
emacs
```

First launch will take several minutes while `straight.el` clones and
compiles every package.

## Personalize before use

The config ships with placeholders. Edit `config.el` or set env vars:

| Placeholder | Where | How to set |
|-------------|-------|------------|
| `Your Name` | `user-full-name`, LaTeX `\author{}` templates | set `USER_FULL_NAME` env var, or edit literal |
| `your-email@example.com` | `user-mail-address` | set `EMAIL` env var, or edit literal |
| `Your Institution` | Beamer `\institute{}` template | edit literal |
| `~/pics/backgrounds/logo.png` | Beamer logo graphic | drop your own image there |
| `~/reveal.js/` | `org-reveal-root` | clone reveal.js to that path |

## License

[MIT](./LICENSE) — © emacs-config contributors.
