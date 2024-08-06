local lsp_zero  = require("lsp-zero")
local lspconfig = require('lspconfig')

function get_current_vue_location()
  local handle = io.popen('node -v')
  local data = handle:read('*a')
  handle:close()

  local result = os.getenv('HOME') .. '/.asdf/installs/nodejs/' .. string.sub(data,2,-2) .. '/lib/node_modules/@vue/typescript-plugin'
  return result
end

lsp_zero.on_attach(function(client, bufnr)
  opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp_zero.setup_servers { 'ruby_lsp', 'lua_ls', 'eslint', 'volar', 'tsserver' }
lsp_zero.format_on_save {
  format_opts = {
    async = false,
    timeout_ms = 10000,
  }, servers = {
    ['eslint'] = { 'javascript' }
  },
}

local cmp       = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_action = lsp_zero.cmp_action()

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    ['<C-Space>'] = cmp.mapping.complete(), 
  }), 
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})
