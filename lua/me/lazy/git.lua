return {
        {
                "lewis6991/gitsigns.nvim",
                opts = {
                        signs = {
                                add = { text = "+" },
                                change = { text = "~" },
                                delete = { text = "_" },
                                topdelete = { text = "‾" },
                                changedelete = { text = "~" },
                        },
                },
        },
        -- {
        --         'tanvirtin/vgit.nvim',
        --         dependencies = {
        --                 'nvim-lua/plenary.nvim',
        --                 'nvim-tree/nvim-web-devicons'
        --         },
        --         event = 'VimEnter',
        --         config = function()
        --                 require('vgit').setup()
        --
        --                 vim.keymap.set("n", "<leader>gg", ":VGit project_commit_preview<CR>",
        --                         { desc = "Project commit preview" })
        --         end,
        -- }
}
