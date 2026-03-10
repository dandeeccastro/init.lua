vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Moving selected items according to indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "//", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>") -- não lembro

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set('i', 'kj', '<ESC>')
vim.keymap.set("n", "<leader>wf", ":w<CR>", { desc = "[W]rite [F]ile" })
vim.keymap.set("n", "<leader>wa", ":wa<CR>", { desc = "[W]rite [A]ll" })

vim.keymap.set('n', '<leader>ff', ":Ex<CR>", { desc = "netrw" })

vim.keymap.set('n', '<leader>yf', function() vim.fn.setreg("+", vim.fn.expand("%")) end,
        { desc = "Copy file path to clipboard" })

vim.keymap.set('n', '<leader>yl', function()
    local value = vim.fn.expand("%") .. ":" .. vim.fn.line(".")
    vim.fn.setreg("+", value)
end, { desc = "Copy file path and line to clipboard" })
