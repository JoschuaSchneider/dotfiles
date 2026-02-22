vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'
vim.o.showmode = false

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.breakindent = true
vim.o.undofile = true

vim.opt.backupcopy = 'yes'

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 50

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true

vim.opt.listchars = { tab = '▎ ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 10

vim.o.confirm = true

vim.opt.title = true
vim.opt.titlestring = 'nvim:%{fnamemodify(getcwd(), ":t")}'

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = {
    suffix = function(diagnostic)
      local suffix = ''
      -- Include code if available
      if diagnostic.code then suffix = string.format(' [%s]', diagnostic.code) end
      -- Append source name
      if diagnostic.source then suffix = suffix .. string.format(' (%s)', diagnostic.source) end
      return suffix, 'Comment'
    end,
  },

  underline = { severity = vim.diagnostic.severity.ERROR },

  virtual_text = false,
  virtual_lines = false,

  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

vim.keymap.set('n', '<leader>qq', '<cmd>:qall<CR>', { desc = 'Quit' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.g.loaded_matchit = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup {
  { 'NMAC427/guess-indent.nvim', event = { 'BufReadPre', 'BufNewFile' }, opts = {} },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = { mappings = vim.g.have_nerd_font },

      spec = {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>o', group = '[O]bsidian', mode = { 'n' } },
      },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    enabled = true,
    cmd = 'Telescope',
    keys = {
      { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = '[S]earch [H]elp' },
      { '<leader>sk', function() require('telescope.builtin').keymaps() end, desc = '[S]earch [K]eymaps' },
      { '<leader>sf', function() require('telescope.builtin').find_files() end, desc = '[S]earch [F]iles' },
      { '<leader>ss', function() require('telescope.builtin').builtin() end, desc = '[S]earch [S]elect Telescope' },
      { '<leader>sw', function() require('telescope.builtin').grep_string() end, mode = { 'n', 'v' }, desc = '[S]earch current [W]ord' },
      { '<leader>sg', function() require('telescope.builtin').live_grep() end, desc = '[S]earch by [G]rep' },
      { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', function() require('telescope.builtin').resume() end, desc = '[S]earch [R]esume' },
      { '<leader>s.', function() require('telescope.builtin').oldfiles() end, desc = '[S]earch Recent Files ("." for repeat)' },
      { '<leader>sc', function() require('telescope.builtin').commands() end, desc = '[S]earch [C]ommands' },
      { '<leader><leader>', function() require('telescope.builtin').buffers() end, desc = '[ ] Find existing buffers' },
      { '<leader>sn', function() require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' } end, desc = '[S]earch [N]eovim files' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          preview = {
            treesitter = false,
            filesize_hook = function(filepath, bufnr, opts)
              local max_bytes = 10000
              local cmd = { 'head', '-c', max_bytes, filepath }
              require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
            end,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          nodescripts = {
            command = 'bun run',
            display_method = 'vsplit',
            ignore_pre_post = true,
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
          vim.keymap.set('n', 'gi', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

          vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

          vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

          vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

          vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })
    end,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup(opts)

      vim.cmd.colorscheme 'tokyonight-night'
    end,

    opts = {
      transparent = true,
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
        comments = { italic = false },
      },
      on_highlights = function(hl, c)
        hl.NormalFloat = {
          bg = c.bg_dark,
          fg = c.fg_dark,
        }
      end,
    },
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'echasnovski/mini.nvim',
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    config = function()
      local filetypes = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'typescript',
        'tsx',
        'javascript',
        'json',
        'css',
      }
      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },
  { import = 'custom.plugins' },
}
