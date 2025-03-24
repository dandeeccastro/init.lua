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

require('lazy').setup({

  -- ABSOLUTAMENTE NECESSÁRIOS
  'tpope/vim-fugitive', -- Git related plugins
  'VonHeikemen/lsp-zero.nvim',
  'neovim/nvim-lspconfig',
  { 'j-hui/fidget.nvim', opts = {}},
  { 'folke/neodev.nvim', opts = {}},
  'hrsh7th/nvim-cmp',
  'L3MON4D3/LuaSnip',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lua',
  'saadparwaiz1/cmp_luasnip',
  'nvim-telescope/telescope.nvim',
  'nvim-lua/plenary.nvim',
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-textobjects',
  'echasnovski/mini.nvim',
  'f-person/git-blame.nvim',
  'ThePrimeagen/Harpoon', -- Some QoL plugins
  'folke/which-key.nvim',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- 'Shatur/neovim-ayu',
  'rose-pine/neovim',
  'nvim-tree/nvim-web-devicons',
  'numToStr/Comment.nvim',
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      }
    }
  },
  'nvim-lualine/lualine.nvim',
}, {})

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
-- function get_current_vue_location()
--   local handle = io.popen('node -v')
--   local data = handle:read('*a')
--   handle:close()
--
--   local result = os.getenv('HOME') .. '/.asdf/installs/nodejs/' .. string.sub(data,2,-2) .. '/lib/node_modules/@vue/typescript-plugin'
--   return result
-- end

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

local lsp_zero  = require("lsp-zero")
local lspconfig = require('lspconfig')

local lsp_attach = function(client, bufnr)
  vim.keymap.set("n", "gd", require('telescope.builtin').lsp_definitions, { buffer = bufnr, remap = false, desc = 'LSP: Go to definitions' })
  vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references, { buffer = bufnr, remap = false, desc = 'LSP: Go to references' })
  vim.keymap.set("n", "gI", require('telescope.builtin').lsp_implementations, { buffer = bufnr, remap = false, desc = 'LSP: Go to implementations' })

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, remap = false, desc = 'LSP: Go to declaration' })
  vim.keymap.set("n", '<leader>D', require('telescope.builtin').lsp_type_definitions, { buffer = bufnr, remap = false, desc = 'LSP: type definitions' })
  vim.keymap.set("n", '<leader>ds', require('telescope.builtin').lsp_document_symbols, { buffer = bufnr, remap = false, desc = 'LSP: document symbols' })
  vim.keymap.set("n", '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { buffer = bufnr, remap = false, desc = 'LSP: workspace symbols' })
  vim.keymap.set("n", '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, remap = false, desc = 'LSP: rename' })
  vim.keymap.set("n", '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, remap = false, desc = 'LSP: code action' })

  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, remap = false, desc = 'LSP: hover' })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { buffer = bufnr, remap = false, desc = 'LSP: go to next diagnostic' })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { buffer = bufnr, remap = false, desc = 'LSP: go to prev diagnostic' })

  -- opts = { buffer = bufnr, remap = false }
  -- lsp_zero.default_keymaps({ buffer = bufnr })

  -- vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  -- vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  -- vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  -- vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  -- vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  -- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

lsp_zero.setup_servers {
  'ruby_lsp',

  'lua_ls',

  'jsonls',
  'ts_ls',
  'eslint',
  'volar',
  'emmet_ls',
  'prismals',

  'gdscript',
}

lsp_zero.configure('tailwindcss', {
  root_dir = function()
    return lsp_zero.dir.find_first({'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.cjs', 'postcss.config.mjs', 'postcss.config.ts'})
  end
})

lsp_zero.format_on_save {
  format_opts = {
    async = false,
    timeout_ms = 10000,
  }, servers = {
    ['eslint'] = { 'javascript', 'typescript', 'typescriptreact' },
    ['ruby_lsp'] = {'ruby'},
  },
}

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
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(), 
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

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'javascript' },

  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },

  sync_install = false,
  ignore_install = {},
  modules = {},
}

require('telescope').setup{
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

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

vim.o.colorcolumn = '100'

require('mini.ai').setup { n_lines = 500 } -- arround/inside melhor
require('mini.surround').setup{} -- adicionar/deletar/substituir surroundings
require('mini.pairs').setup{}
require('mini.files').setup{}
-- require('mini.diff').setup{}

vim.keymap.set('n', '<leader>ff', MiniFiles.open, { desc = '[FF]ile' })

-- local statusline = require('mini.statusline')
-- statusline.setup { use_icons = vim.g.have_nerd_font }
-- statusline.section_location = function()
--   return '%2l:%-2v'
-- end
--
require('gitblame').setup { opts = { enabled = false } }

-- NICE TO HAVE
local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = "[Ha]rpoon file" })
vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = "[Harpoon] Menu" })

vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end, { desc = '[Harpoon] First file' })
vim.keymap.set('n', '<C-j>', function() ui.nav_file(2) end, { desc = '[Harpoon] Second file' })
vim.keymap.set('n', '<C-k>', function() ui.nav_file(3) end, { desc = '[Harpoon] Third file' })
vim.keymap.set('n', '<C-l>', function() ui.nav_file(4) end, { desc = '[Harpoon] Fourth file' })

vim.o.timeout = true
vim.o.timeoutlen = 300

vim.cmd("colorscheme rose-pine")

require('Comment').setup {}

require('lualine').setup {
  options = {
    theme = 'ayu'
  }
}
