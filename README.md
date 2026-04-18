# emacs-config

Personal GNU Emacs configuration built on
[`straight.el`](https://github.com/radian-software/straight.el) and
[`use-package`](https://github.com/jwiegley/use-package).

You can freely copy and download parts or all of these elisp files.
Happy hacking!

## Features

- **Knowledge management** — `org-mode`, `org-roam`, `org-roam-ui`,
  `citar`/`bibtex` + `org-cite`, Anki.
- **Document authoring** — custom LaTeX classes (article, book, Beamer),
  `ox-reveal`, Quarto, Markdown, Graphviz, `org-babel`.
- **AI assistants** — `gptel`, GitHub Copilot,
  [`claude-code-ide`](https://github.com/manzaltu/claude-code-ide.el),
  multiple MCP servers (filesystem, GitHub, Graphlit, Qdrant).
- **Editing** — `evil`, `vertico`, `corfu`, `cape`, PDF Tools, Magit.
- **Terminals & files** — `vterm`, `eshell`, `dired`. 
- **UI** — Modus themes, JetBrains Mono, `nerd-icons`, variable-pitch
  prose, per-mode cursor colors.
- **Performance** — native compilation, GC tuning, deferred file-handler
  alist, session persistence (`desktop`, `recentf`).

## Files

| File | Purpose |
|------|---------|
| `early-init.el` | Runs before package init — GC, frame defaults, native-comp. |
| `init.el` | Entry point; loads `config.el`. |
| `config.el` | Main configuration (all `use-package` declarations). |
| `custom.el` | Emacs's customization values. |

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
| `~/path/to/logo.png` | Beamer logo graphic | drop your own image there |
| `~/reveal.js/` | `org-reveal-root` | clone reveal.js to that path |

## License

[MIT](./LICENSE) — © emacs-config contributors.
