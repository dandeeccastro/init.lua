return {
        {
                "folke/tokyonight.nvim",
                priority = 1000, -- Make sure to load this before all the other start plugins.
                config = function()
                        ---@diagnostic disable-next-line: missing-fields
                        require("tokyonight").setup({
                                styles = {
                                        comments = { italic = false }, -- Disable italics in comments
                                },
                        })

                        -- Load the colorscheme here.
                        -- Like many other themes, this one has different styles, and you could load
                        -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
                        vim.cmd.colorscheme("tokyonight-storm")
                end,
        },
        {
                'nvim-lualine/lualine.nvim',
                dependencies = { 'nvim-tree/nvim-web-devicons' },
                config = function()
                        require('lualine').setup()
                end
        },
        {
                "nvim-treesitter/nvim-treesitter",
                build = ":TSUpdate",
                -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
                opts = {
                        ensure_installed = {
                                "bash",
                                "c",
                                "diff",
                                "html",
                                "lua",
                                "luadoc",
                                "markdown",
                                "markdown_inline",
                                "query",
                                "vim",
                                "vimdoc",
                        },
                        -- Autoinstall languages that are not installed
                        auto_install = true,
                        highlight = {
                                enable = true,
                                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                                --  If you are experiencing weird indenting issues, add the language to
                                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                                additional_vim_regex_highlighting = { "ruby" },
                        },
                        indent = { enable = true, disable = { "ruby" } },
                },
                -- There are additional nvim-treesitter modules that you can use to interact
                -- with nvim-treesitter. You should go explore a few and see what interests you:
                --
                --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
                --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
                --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        },
        {
                -- Useful plugin to show you pending keybinds.
                "folke/which-key.nvim",
                event = "VimEnter", -- Sets the loading event to 'VimEnter'
                opts = {
                        -- delay between pressing a key and opening which-key (milliseconds)
                        -- this setting is independent of vim.o.timeoutlen
                        delay = 0,
                        icons = {
                                -- set icon mappings to true if you have a Nerd Font
                                mappings = vim.g.have_nerd_font,
                                -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
                                -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
                                keys = vim.g.have_nerd_font and {} or {
                                        Up = "<Up> ",
                                        Down = "<Down> ",
                                        Left = "<Left> ",
                                        Right = "<Right> ",
                                        C = "<C-…> ",
                                        M = "<M-…> ",
                                        D = "<D-…> ",
                                        S = "<S-…> ",
                                        CR = "<CR> ",
                                        Esc = "<Esc> ",
                                        ScrollWheelDown = "<ScrollWheelDown> ",
                                        ScrollWheelUp = "<ScrollWheelUp> ",
                                        NL = "<NL> ",
                                        BS = "<BS> ",
                                        Space = "<Space> ",
                                        Tab = "<Tab> ",
                                        F1 = "<F1>",
                                        F2 = "<F2>",
                                        F3 = "<F3>",
                                        F4 = "<F4>",
                                        F5 = "<F5>",
                                        F6 = "<F6>",
                                        F7 = "<F7>",
                                        F8 = "<F8>",
                                        F9 = "<F9>",
                                        F10 = "<F10>",
                                        F11 = "<F11>",
                                        F12 = "<F12>",
                                },
                        },

                        -- Document existing key chains
                        spec = {
                                { "<leader>s", group = "[S]earch" },
                                { "<leader>t", group = "[T]oggle" },
                                { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
                        },
                },
        }
}
