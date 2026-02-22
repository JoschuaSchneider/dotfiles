return {
  'saghen/blink.cmp',
  build = 'cargo build --release',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = '1.*',
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'select_and_accept', 'fallback' },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = true },
    },

    cmdline = {
      keymap = { preset = 'default' },
      completion = { menu = { auto_show = true } },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },
}
