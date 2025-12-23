return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
    { 'qvalentin/helm-ls.nvim', ft = 'helm' },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gy', require('telescope.builtin').lsp_type_definitions, '[G]oto T[Y]pe Definition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<leader>k', vim.diagnostic.open_float, 'Hover Diagnostics')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Configure diagnostics to show LSP source name at the end in muted color
    vim.diagnostic.config {
      float = {
        suffix = function(diagnostic)
          local suffix = ''
          -- Include code if available
          if diagnostic.code then
            suffix = string.format(' [%s]', diagnostic.code)
          end
          -- Append source name
          if diagnostic.source then
            suffix = suffix .. string.format(' (%s)', diagnostic.source)
          end
          return suffix, 'Comment'
        end,
      },
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      emmet_ls = {
        filetypes = { 'astro', 'css', 'eruby', 'html', 'htmldjango', 'less', 'pug', 'sass', 'scss', 'svelte', 'vue', 'htmlangular' },
      },
      shopify_theme_ls = {},
      clangd = {},
      gopls = {},
      rust_analyzer = {},
      helm_ls = {
        ['helm-ls'] = {
          yamlls = {
            path = 'yaml-language-server',
          },
        },
      },
      sqls = {},
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
      angularls = {
        filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'angular.html' },
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
      phpactor = {},
      graphql = {},

      basedpyright = {},

      -- swift, objective-c
      sourcekit = {
        cmd = { '/usr/bin/sourcekit-lsp' },
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      },

      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
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
      solidity_ls = {},
    }

    require('mason').setup()

    local ensure_installed = {}
    for key, _ in pairs(servers or {}) do
      if key ~= 'sourcekit' then
        table.insert(ensure_installed, key)
      end
    end
    vim.list_extend(ensure_installed, {
      'stylua',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    local function setup_sourcekit()
      local server = servers.sourcekit or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      vim.lsp.config('sourcekit', server)
      vim.lsp.enable('sourcekit')
    end

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          if string.find(server_name, 'tailwind') then
            print(server_name)
          end
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          vim.lsp.config(server_name, server)
          vim.lsp.enable(server_name)
        end,
      },
    }

    -- COMMENTED OUT: vtsls setup (temporarily using ts_ls)
    -- local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
    -- local vue_plugin = {
    --   name = '@vue/typescript-plugin',
    --   location = vue_language_server_path,
    --   languages = { 'vue' },
    --   configNamespace = 'typescript',
    -- }
    -- local vtsls_config = {
    --   settings = {
    --     vtsls = {
    --       tsserver = {
    --         globalPlugins = {
    --           vue_plugin,
    --         },
    --       },
    --     },
    --     typescript = {
    --       tsserver = {
    --         pluginPaths = {}, -- Enables workspace plugins from tsconfig.json
    --       },
    --     },
    --   },
    --   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    -- }
    -- -- If you are on most recent `nvim-lspconfig`
    -- local vue_ls_config = {
    --   init_options = {
    --     typescript = {
    --       tsdk = vim.fn.stdpath 'data' .. '/mason/packages/typescript-language-server/node_modules/typescript/lib',
    --     },
    --   },
    -- }
    --
    -- vim.lsp.config('vtsls', vtsls_config)
    -- vim.lsp.config('vue_ls', vue_ls_config)
    -- vim.lsp.enable { 'vtsls', 'vue_ls' }

    -- Plain TypeScript LSP setup
    local ts_ls_config = {
      capabilities = vim.tbl_deep_extend('force', {}, capabilities),
      init_options = {
        plugins = {
          {
            name = '@0no-co/graphqlsp',
            location = vim.fn.getcwd() .. '/node_modules/@0no-co/graphqlsp',
          },
        },
      },
    }
    vim.lsp.config('ts_ls', ts_ls_config)
    vim.lsp.enable('ts_ls')

    setup_sourcekit()
  end,
}
