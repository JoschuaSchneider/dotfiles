# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Neovim configuration based on **kickstart.nvim**, deployed via GNU Stow from a larger dotfiles repository. The configuration uses a modular architecture with lazy.nvim as the plugin manager.

## Key Commands

### Neovim Health Check
```bash
nvim -c "checkhealth kickstart"
```

### Formatting
- **In Neovim**: `<leader>f` formats the current buffer
- **Command**: `:ConformInfo` shows active formatters

### Diagnostics
- **In Neovim**: `<leader>k` shows diagnostics for current position
- **In Neovim**: `<leader>sd` searches all diagnostics

## Architecture

The configuration follows a three-tier structure:

1. **Core configuration** (`init.lua`): Main settings, keymaps, and plugin specs
2. **Kickstart plugins** (`lua/kickstart/plugins/`): Default kickstart modules for common functionality
3. **Custom plugins** (`lua/custom/plugins/`): User-specific plugin configurations

### Plugin Loading Flow
- `init.lua` sets up lazy.nvim and basic options
- Plugins are loaded from:
  - Direct specifications in `init.lua`
  - `kickstart.plugins.*` modules
  - `custom.plugins.*` modules

### Key Design Patterns
- **Lazy loading**: Plugins load on specific events for performance
- **LSP-first**: Comprehensive LSP setup with Mason for automatic server installation
- **Modular configuration**: Each plugin has its own file returning a plugin spec table

## Development Workflow

### Adding a New Plugin
1. Create a new file in `lua/custom/plugins/plugin-name.lua`
2. Return a plugin specification table
3. The file will be automatically loaded by lazy.nvim

### Modifying Existing Configuration
- **Core settings**: Edit `init.lua`
- **Plugin-specific**: Edit the relevant file in `lua/kickstart/plugins/` or `lua/custom/plugins/`
- **LSP configuration**: Edit `lua/custom/plugins/lsp.lua` for language servers and Mason setup
- **Formatter/Linter**: Check `lua/custom/plugins/conform.lua` for conform.nvim and `lua/kickstart/plugins/lint.lua`

### Key Bindings Convention
- Leader key is Space
- Plugin keymaps typically use `<leader>` prefix
- Navigation uses standard vim motions

## Important Files and Their Purposes

- `init.lua`: Core configuration, basic options, and core plugin specs
- `lua/custom/plugins/lsp.lua`: LSP configuration, Mason setup, and language server definitions
- `lazy-lock.json`: Plugin version lock file (do not edit manually)
- `lua/kickstart/plugins/lint.lua`: Linting configuration
- `lua/custom/plugins/conform.lua`: Formatting configuration with conform.nvim
- `lua/custom/plugins/`: User's custom plugin configurations

## Language-Specific Support

The configuration includes specialized support for:
- **Flutter**: via flutter-tools.lua (lazy loaded for Dart files)
- **Angular**: custom TreeSitter grammar and formatters
- **Go/TinyGo**: LSP and formatting configured
- **TypeScript/JavaScript**: ESLint integration, vtsls LSP
- **Vue.js**: TypeScript plugin integration

## Deployment

This configuration is deployed using GNU Stow:
```bash
./link.sh  # From the dotfiles root directory
```

The configuration expects to be symlinked to `~/.config/nvim/`.