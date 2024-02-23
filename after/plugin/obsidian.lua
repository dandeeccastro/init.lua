require('obsidian').setup {
    workspaces = {
        {
            name = 'Escritor',
            path = "/home/dundee/Documentos/20-29 PROJETOS PESSOAIS/22 PROJETOS CRIATIVOS/22.01 HISTÓRIAS"
        }
    }
}

vim.keymap.set('n', '<leader>osf', vim.cmd.ObsidianSearch, { desc = '[Obsidian] [S]earch [F]ile'})
vim.keymap.set('n', '<leader>onf', vim.cmd.ObsidianNew, { desc = '[Obsidian] [N]ew [F]ile'})
vim.keymap.set('n', '<leader>orn', vim.cmd.ObsidianRename, { desc = '[Obsidian] [R]e[N]ame'})
vim.keymap.set('n', '<leader>osw', vim.cmd.ObsidianWorkspace, { desc = '[Obsidian] [S]witch [W]orkspace'})
