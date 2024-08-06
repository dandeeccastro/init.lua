-- SETTING STUFF
--
-- Globals
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- WO
vim.wo.number = true -- Relative line numbers
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes' -- Keep signcolumn on by default

-- O
vim.o.hlsearch = false -- Highlight on search
vim.o.mouse = '' -- No mouse mode
-- vim.o.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Save undo history
vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.o.termguicolors = true -- NOTE: You should make sure your terminal supports this
vim.o.scrolloff = 5
vim.o.cursorline = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.linebreak = true
vim.o.conceallevel= 2
vim.o.showmode= false -- a status bar já mostra
vim.o.inccommand= 'split' -- ver substituições possíveis enquanto digita, i guess

-- GENERIC REMAPS
vim.keymap.set('i', 'kj', '<ESC>')

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }) -- Remap for dealing with word wrap
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Moving selected items according to indentation
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "//", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>") -- não lembro

vim.keymap.set("n", "<leader>wf", ":w<CR>", { desc = "[W]rite [F]ile" })
vim.keymap.set("n", "<leader>wa", ":wa<CR>", { desc = "[W]rite [A]ll" })

vim.keymap.set('n', '<leader>yy','"+yy', { desc = 'Yank line to clipboard' }) -- Yanking to clipboard
vim.keymap.set('v', '<leader>y','"+y', { desc = 'Yank selection to clipboard' })

vim.keymap.set('n', '<leader>p','"+p', { desc = 'Paste clipboard' }) -- pasting from clipboard

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- LAZY PACKAGE MANAGER
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

function get_current_vue_location()
  local handle = io.popen('node -v')
  local data = handle:read('*a')
  handle:close()

  local result = os.getenv('HOME') .. '/.asdf/installs/nodejs/' .. string.sub(data,2,-2) .. '/lib/node_modules/@vue/typescript-plugin'
  return result
end

require('lazy').setup({

  'tpope/vim-rhubarb',
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'mattn/emmet-vim',
  'nvim-tree/nvim-web-devicons',

  {
    'tpope/vim-fugitive', -- Git related plugins
    config = function()
      vim.keymap.set('n', '<leader>gg', vim.cmd.Git, { desc = '[G]it [G]ud' }) -- tem que ter um jeito melhor...

      local dandeeccastro_fugitive = vim.api.nvim_create_augroup("dandeeccastro_fugitive", {})
      local autocmd = vim.api.nvim_create_autocmd
      autocmd("BufWinEnter", {
        group = dandeeccastro_fugitive,
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = {buffer = bufnr, remap = false}

          vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git('push')
          end, { buffer = bufnr, remap = false, desc = '[Git] [p]ush'})

          vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git('pull')
          end, { buffer = bufnr, remap = false, desc = '[Git] [P]ull'})

          vim.keymap.set("n", "<leader>t", ":Git push -u origin ", { buffer = bufnr, remap = false, desc = '[Git] push -u origin ___'});
        end,
      })
    end
  },


  {
    'f-person/git-blame.nvim',
    config = function()
      require('gitblame').setup { enable = false }
    end
  },


  {
    'ThePrimeagen/Harpoon', -- Some QoL plugins
    config = function()
      local mark = require('harpoon.mark')
      local ui = require('harpoon.ui')

      vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = "[Ha]rpoon file" })
      vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = "[Harpoon] Menu" })

      vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end, { desc = '[Harpoon] First file' })
      vim.keymap.set('n', '<C-j>', function() ui.nav_file(2) end, { desc = '[Harpoon] Second file' })
      vim.keymap.set('n', '<C-k>', function() ui.nav_file(3) end, { desc = '[Harpoon] Third file' })
      vim.keymap.set('n', '<C-l>', function() ui.nav_file(4) end, { desc = '[Harpoon] Fourth file' })
    end
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {}
  },

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      'neovim/nvim-lspconfig',
      { 'j-hui/fidget.nvim', opts = {}},
      { 'folke/neodev.nvim', opts = {}},
    },
    config = function()
      local lsp_zero  = require("lsp-zero")
      local lspconfig = require('lspconfig')

      lsp_zero.on_attach(function(client, bufnr)
        opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
      end)

      lsp_zero.setup_servers { 'ruby_lsp', 'lua_ls', 'eslint', 'volar', 'gdscript' }
      lspconfig.tsserver.setup {
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              location = get_current_vue_location(),
              languages = {"javascript", "typescript", "vue"},
            },
          },
        },
        filetypes = { "javascript", "typescript", "vue"}
      }
      lsp_zero.format_on_save {
        format_opts = {
          async = false,
          timeout_ms = 10000,
        }, servers = {
          ['eslint'] = { 'javascript' }
        },
      }
    end
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip/loaders/from_vscode').load()
          end
        },
      },
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local luasnip = require('luasnip')
      luasnip.config.setup({})

      local snippet = luasnip.snippet
      local text_node = luasnip.text_node
      local choice_node = luasnip.choice_node
      local insert_node = luasnip.insert_node
      local fmt = require('luasnip.extras.fmt').fmt
      local rep = require('luasnip.extras').rep

      vim.keymap.set({ 'i', 's' }, '<C-j>', function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { silent = true})

      vim.keymap.set({ 'i', 's' }, '<C-k>', function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { silent = true})

      vim.keymap.set({ 'i', 's' }, '<C-n>', function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end)

      luasnip.add_snippets('javascript', {
        snippet('plghandle', fmt([[
        exports.handle = async (plg, event) => {
          []
        };
        ]], { insert_node(1) }, { delimiters = '[]'})),

        snippet('plgaxios', fmt([[
        plg.axios({
          method: '[]',
          url: `${event.meta.baseURI}/[]`,
          params: {[]},
          data: {[]},
        });
        ]], { choice_node(1, {
          text_node("GET"),
          text_node("POST"),
          text_node("PUT"),
          text_node("DELETE"),
          text_node("OPTIONS"),
        }), insert_node(2), insert_node(3), insert_node(4)  },
        { delimiters = '[]'})),

        snippet('plgtest', fmt([[
        const plg = require('pluga-plg');
        const { expect } = require('chai');

        const [] = require('../../lib/[]s/[]');

        const event = {
          meta: {
            baseURI: process.env.BASE_URI,
          },
          auth: {
            access_token: process.env.ACCESS_TOKEN,
          },
          input: {[]},
        };

        describe('[]', () => {
          []
        })
        ]], {
          choice_node(1, {
            text_node('trigger'),
            text_node('action'),
          }),
          rep(1),
          insert_node(2),
          insert_node(3),
          insert_node(4),
          insert_node(5),
        }, { delimiters = '[]'})),

        snippet('plgmeta', fmt([[
        exports.metaConfig = {
          name: {
            pt_BR: '<>',
            en: '<>',
          },
          description: {
            pt_BR: '<>',
            en: '<>',
          },
          configuration_fields: {
            <>
          },
          <>_fields: {
            type: 'local',
            fields: [
            <>
            ],
          },
        };
        ]], {
          insert_node(1),
          insert_node(2),
          insert_node(3),
          insert_node(4),
          insert_node(5),
          choice_node(6, {
            text_node('trigger'),
            text_node('action'),
          }),
          insert_node(7),
        }, { delimiters = '<>'})),
      })

      luasnip.filetype_extend("ruby", {"rails"})
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-l>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(), 
          ['<Tab>'] = nil,
          ['<S-Tab>'] = nil,
        }), 
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

    end
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end
  },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
          vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
          vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
        end,
      }
    end
  },

  -- {
  --   -- Theme inspired by Atom
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'catppuccin-mocha'
  --   end,
  -- },
  {
    'dasupradyumna/midnight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'midnight'
    end
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'javascript' },

        sync_install = false,
        ignore_install = {},
        modules = {},

        auto_install = true,

        highlight = { enable = true, },
        -- indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')

      -- See `:help telescope.builtin`
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.o.foldtext = ''
    end
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 } -- arround/inside melhor
      require('mini.surround').setup{} -- adicionar/deletar/substituir surroundings

      local statusline = require('mini.statusline')
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end
  },

  'folke/zen-mode.nvim',
}, {})
