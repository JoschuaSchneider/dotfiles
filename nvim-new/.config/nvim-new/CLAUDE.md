# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim configuration using **lazy.nvim** as the plugin manager. Focused on web development (TypeScript, Angular, React/TSX, GraphQL, Tailwind CSS) with secondary support for Lua, Go, Python, and Solidity.

## Structure

- `init.lua` — Entry point. Contains vim options, diagnostics config, leader key (`<Space>`), and inline plugin specs (gitsigns, telescope, which-key, treesitter, tokyonight, mini statusline, todo-comments, guess-indent).
- `lua/custom/plugins/` — Modular plugin specs, each file is auto-imported by lazy.nvim via `{ import = 'custom.plugins' }`.
- `lazy-lock.json` — Dependency lock file managed by lazy.nvim.

## Architecture

**Plugin loading:** lazy.nvim bootstraps itself in init.lua, then loads two sources: inline specs defined in init.lua and all files from `lua/custom/plugins/`.

**LSP stack:** `lsp.lua` configures mason + mason-tool-installer for auto-installing servers, blink.cmp for completion, LuaSnip for snippets, and fidget.nvim for progress. Servers: ts_ls, tailwindcss, lua_ls, html, cssls, jsonls (with schemastore), emmet_ls, biome, graphql.

**Formatting:** conform.nvim with format-on-save and LSP fallback. Toggle with `:FormatDisable`/`:FormatEnable`.

**Linting:** nvim-lint runs eslint (JS/TS) and markdownlint on BufEnter/BufWritePost/InsertLeave.

**Navigation:** Telescope for fuzzy finding (`<leader>s*` bindings), Harpoon v2 for bookmarks (`<leader>a`, `<C-e>`, `<C-h/j/k/l>`), neo-tree for file tree (right-aligned, has custom Angular `ng generate` integration via `g` key).

## Key Conventions

- All plugin specs return a Lua table conforming to lazy.nvim's plugin spec format.
- Color scheme is tokyonight-night with full transparency.
- Diagnostics: severity-sorted, no virtual text, float on jump. Only underline for ERROR severity.
- macOS-aware: nvim-spectre uses `sed` (BSD) instead of GNU sed.
