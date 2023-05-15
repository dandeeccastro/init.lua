require('nvim-treesitter.configs').setup({
  ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust" },
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})