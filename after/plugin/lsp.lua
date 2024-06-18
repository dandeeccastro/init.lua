local lsp = require("lsp-zero")

lsp.preset("recommended")

-- require('mason').setup({})
-- require('mason-lspconfig').setup({
--   ensure_installed = { 'tsserver', 'rust_analyzer', 'lua_ls' },
--   handlers = {
--     function(server_name)
--       require('lspconfig')[server_name].setup({})
--     end,
--     ['ruby_lsp'] = function()
--       require('lspconfig')['ruby_lsp'].setup {
--         cmd = { os.getenv('HOME') .. '/.asdf/shims/ruby-lsp' },
--       }
--     end
--   },
-- })

local lspconfig = require('lspconfig')

-- lspconfig.solargraph.setup {}
lspconfig.ruby_lsp.setup {}
lspconfig.eslint.setup {
  on_attach = function (client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'EslintFixAll',
    })
  end
}
lspconfig.lua_ls.setup {}
lspconfig.tsserver.setup {}

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(), }), snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { buffer = bufnr, remap = false, desc='Go to definition' })
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { buffer = bufnr, remap = false, desc = 'Hover' })
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, { buffer = bufnr, remap = false, desc= 'Workspace Symbol' })
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, { buffer = bufnr, remap = false, desc='Diagnostics' })
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, { buffer = bufnr, remap = false, desc='Goto next' })
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, { buffer = bufnr, remap = false, desc='Goto prev' })
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, { buffer = bufnr, remap = false, desc= 'Code action' })
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, { buffer = bufnr, remap = false, desc='References' })
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, { buffer = bufnr, remap = false, desc='Rename' })
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { buffer = bufnr, remap = false, desc='Signature help' })
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
