vim.keymap.set('i', 'kj', '<ESC>')

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }) -- Remap for dealing with word wrap
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Moving selected items according to indentation
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "//", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>")

vim.keymap.set("n", "<leader>wf", ":w<CR>", { desc = "[W]rite [F]ile" })
vim.keymap.set("n", "<leader>wa", ":wa<CR>", { desc = "[W]rite [A]ll" })

