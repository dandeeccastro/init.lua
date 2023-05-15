-- searching
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- tabstops and other visual aids
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 5

-- old vim style
vim.opt.guicursor = ""

-- no mouses allowed here
vim.opt.mouse = ""

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- indentation
vim.opt.smartindent = true

vim.opt.termguicolors = true

vim.opt.updatetime = 50

vim.opt.signcolumn = "yes"
