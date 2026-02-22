return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
    'b0o/schemastore.nvim',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('grn', vim.lsp.buf.rename, '[G]oto [R]e[n]ame')

        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        map('<leader>k', vim.diagnostic.open_float, 'Hover Diagnostics')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local servers = {
      emmet_ls = {
        filetypes = { 'astro', 'css', 'eruby', 'html', 'htmldjango', 'less', 'pug', 'sass', 'scss', 'svelte', 'vue', 'htmlangular' },
      },
      biome = {
        filetypes = {
          'astro',
          'css',
          'graphql',
          'html',
          'javascript',
          'javascriptreact',
          'json',
          'jsonc',
          'svelte',
          'typescript',
          'typescript.tsx',
          'typescriptreact',
          'vue',
          'svg',
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },
      html = {},
      cssls = {},
      graphql = {
        filetypes = {
          'graphql',
          'typescript',
          'javascript',
          'typescriptreact',
          'javascriptreact',
        },
      },
      tailwindcss = {
        settings = {
          tailwindCSS = {
            classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
            classFunctions = { 'cva', 'cn', 'clsx' },
            includeLanguages = {
              eelixir = 'html-eex',
              elixir = 'phoenix-heex',
              eruby = 'erb',
              heex = 'phoenix-heex',
              htmlangular = 'html',
              templ = 'html',
            },
            lint = {
              cssConflict = 'warning',
              invalidApply = 'error',
              invalidConfigPath = 'error',
              invalidScreen = 'error',
              invalidTailwindDirective = 'error',
              invalidVariant = 'error',
              recommendedVariantOrder = 'warning',
            },
            validate = true,
          },
        },
      },
      ts_ls = {

        init_options = {
          plugins = {
            {
              name = '@0no-co/graphqlsp',
              location = vim.fn.getcwd() .. '/node_modules/@0no-co/graphqlsp',
            },
          },
        },
      },
    }

    require('mason-tool-installer').setup {
      ensure_installed = {
        'stylua',
        'typescript-language-server',
        'tailwindcss-language-server',
        'emmet-language-server',
        'graphql-language-service-cli',
        'lua-language-server',
      },
    }

    for name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end

    vim.lsp.config('lua_ls', {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            --  See https://github.com/neovim/nvim-lspconfig/issues/3189
            library = vim.api.nvim_get_runtime_file('', true),
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })
    vim.lsp.enable 'lua_ls'
  end,
}
