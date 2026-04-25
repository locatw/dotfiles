# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Holds the user's VS Code `settings.json` / `keybindings.json` and a top-level `.gitignore`. There is no installer script — settings are synced manually (or via VS Code Settings Sync). No build, test, or lint pipeline; changes take effect once VS Code re-reads the files.

## VS Code config (`vscode/`)

- `settings.json` configures the **VSCodeVim** extension: leader is `<Space>`. Normal-mode leader bindings: `<leader>s` / `<leader>v` split editors, `<leader>h` / `<leader>l` move between editor groups, `<leader>t` toggles sidebar visibility, `<leader>fe` focuses sidebar, `<leader>=` evens editor widths.
- Go uses `golangci-lint` on save with the language server enabled (`go.lintTool`, `go.lintOnSave: workspace`, `go.useLanguageServer`).
- File-type indent overrides set `editor.tabSize: 2` for `ruby`, `html`, `javascript`, `vue`. `*.vue` is associated with the `vue` language.
- `shellformat.path` is hard-coded to a Windows path (`C:\bin\shfmt_v2.6.4_windows_amd64.exe`) and `terminal.integrated.shell.windows` points at `cmd.exe` — this file is Windows-targeted; do not reflexively rewrite Windows paths to POSIX.
- `keybindings.json` rebinds `` ctrl+` `` to toggle focus between terminal and editor (one binding for each direction) and makes `escape` hide the sidebar when the sidebar is focused.
