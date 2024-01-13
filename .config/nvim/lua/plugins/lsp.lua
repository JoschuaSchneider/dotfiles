return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- "Hoffs/omnisharp-extended-lsp.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        tsserver = {
          single_file_support = false,
          init_options = {
            hostInfo = "neovim",
          },
          preferences = {
            importModuleSpecifierPreference = "auto",
          },
        },
        denols = {},
        angularls = {},
        phpactor = {},
        kotlin_language_server = {},
        cssls = {},
        graphql = {
          filetypes = {
            "typescriptreact",
            "javascriptreact",
            "graphql",
          },
        },
      },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
        denols = function(server, server_opts)
          server_opts.root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
          return false
        end,
        phpactor = function(server, server_opts)
          server_opts.root_dir = require("lspconfig.util").root_pattern("composer.json", ".git")
          return false
        end,
        graphql = function(server, server_opts)
          server_opts.root_dir = require("lspconfig.util").root_pattern(
            "schema.graphql",
            ".git",
            ".graphqlrc*",
            ".graphql.config.*",
            "graphql.config.*"
          )
          return false
        end,
      },
    },
  },
  -- TODO: replace none-ls with conform
  {
    "nvimtools/none-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(
          ".null-ls-root",
          "package.json",
          ".neoconf.json",
          "Makefile",
          ".git"
        ),
        sources = {
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.phpcsfixer,
        },
      }
    end,
  },
}
