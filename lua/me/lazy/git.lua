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
        {
                "FabijanZulj/blame.nvim",
                lazy = false,
                config = function()
                        require('blame').setup {}
                end,
        },
}
