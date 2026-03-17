return {
        {
                -- Autocompletion
                "saghen/blink.cmp",
                event = "VimEnter",
                version = "1.*",
                dependencies = {
                        {
                                "L3MON4D3/LuaSnip",
                                version = "2.*",
                                build = (function()
                                        -- Build Step is needed for regex support in snippets.
                                        -- This step is not supported in many windows environments.
                                        -- Remove the below condition to re-enable on windows.
                                        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                                                return
                                        end
                                        return "make install_jsregexp"
                                end)(),
                                dependencies = {
                                        -- `friendly-snippets` contains a variety of premade snippets.
                                        --    See the README about individual language/framework/plugin snippets:
                                        --    https://github.com/rafamadriz/friendly-snippets
                                        -- {
                                        --   'rafamadriz/friendly-snippets',
                                        --   config = function()
                                        --     require('luasnip.loaders.from_vscode').lazy_load()
                                        --   end,
                                        -- },
                                },
                                opts = {},
                        },
                        "folke/lazydev.nvim",
                },
                --- @module 'blink.cmp'
                --- @type blink.cmp.Config
                opts = {
                        keymap = {
                                -- 'default' (recommended) for mappings similar to built-in completions
                                --   <c-y> to accept ([y]es) the completion.
                                --    This will auto-import if your LSP supports it.
                                --    This will expand snippets if the LSP sent a snippet.
                                -- 'super-tab' for tab to accept
                                -- 'enter' for enter to accept
                                -- 'none' for no mappings
                                --
                                -- For an understanding of why the 'default' preset is recommended,
                                -- you will need to read `:help ins-completion`
                                --
                                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                                --
                                -- All presets have the following mappings:
                                -- <tab>/<s-tab>: move to right/left of your snippet expansion
                                -- <c-space>: Open menu or open docs if already open
                                -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
                                -- <c-e>: Hide menu
                                -- <c-k>: Toggle signature help
                                --
                                -- See :h blink-cmp-config-keymap for defining your own keymap
                                preset = "super-tab",

                                -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                                --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                        },

                        appearance = {
                                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                                -- Adjusts spacing to ensure icons are aligned
                                nerd_font_variant = "mono",
                        },

                        completion = {
                                -- By default, you may press `<c-space>` to show the documentation.
                                -- Optionally, set `auto_show = true` to show the documentation after a delay.
                                documentation = { auto_show = false, auto_show_delay_ms = 500 },
                        },

                        sources = {
                                default = { "lsp", "path", "snippets", "lazydev" },
                                providers = {
                                        lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
                                },
                        },

                        snippets = { preset = "luasnip" },

                        -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
                        -- which automatically downloads a prebuilt binary when enabled.
                        --
                        -- By default, we use the Lua implementation instead, but you may enable
                        -- the rust implementation via `'prefer_rust_with_warning'`
                        --
                        -- See :h blink-cmp-config-fuzzy for more information
                        fuzzy = { implementation = "lua" },

                        -- Shows a signature help window while you type arguments for a function
                        signature = { enabled = true },
                },
        },
        {
                -- Autoformat
                "stevearc/conform.nvim",
                event = { "BufWritePre" },
                cmd = { "ConformInfo" },
                keys = {
                        {
                                "<leader>f",
                                function()
                                        require("conform").format({ async = true, lsp_format = "fallback" })
                                end,
                                mode = "",
                                desc = "[F]ormat buffer",
                        },
                },
                opts = {
                        notify_on_error = false,
                        format_on_save = function(bufnr)
                                -- Disable "format_on_save lsp_fallback" for languages that don't
                                -- have a well standardized coding style. You can add additional
                                -- languages here or re-enable it for the disabled ones.
                                local disable_filetypes = { c = true, cpp = true }
                                if disable_filetypes[vim.bo[bufnr].filetype] then
                                        return nil
                                else
                                        return {
                                                timeout_ms = 500,
                                                lsp_format = "fallback",
                                        }
                                end
                        end,
                        formatters_by_ft = {
                                -- lua = { 'stylua' },
                                -- Conform can also run multiple formatters sequentially
                                -- python = { "isort", "black" },
                                --
                                -- You can use 'stop_after_first' to run the first available formatter from the list
                                -- javascript = { "prettierd", "prettier", stop_after_first = true },
                        },
                },
        },
        {
                "maskudo/devdocs.nvim",
                lazy = false,
                dependencies = {
                        "folke/snacks.nvim",
                },
                cmd = { "DevDocs" },
                keys = {
                        {
                                "<leader>ho",
                                mode = "n",
                                "<cmd>DevDocs get<cr>",
                                desc = "Get Devdocs",
                        },
                        {
                                "<leader>hi",
                                mode = "n",
                                "<cmd>DevDocs install<cr>",
                                desc = "Install Devdocs",
                        },
                        {
                                "<leader>hv",
                                mode = "n",
                                function()
                                        local devdocs = require("devdocs")
                                        local installedDocs = devdocs.GetInstalledDocs()
                                        vim.ui.select(installedDocs, {}, function(selected)
                                                if not selected then
                                                        return
                                                end
                                                local docDir = devdocs.GetDocDir(selected)
                                                -- prettify the filename as you wish
                                                Snacks.picker.files({ cwd = docDir })
                                        end)
                                end,
                                desc = "Get Devdocs",
                        },
                        {
                                "<leader>hd",
                                mode = "n",
                                "<cmd>DevDocs delete<cr>",
                                desc = "Delete Devdoc",
                        }
                },
                opts = {
                        ensure_installed = {
                                -- "go",
                                "html",
                                -- "dom",
                                "http",
                                -- "css",
                                "javascript",
                                "typescript",
                                -- "rust",
                                -- some docs such as lua require version number along with the language name
                                -- check `DevDocs install` to view the actual names of the docs
                                "lua~5.1",
                                -- "openjdk~21"
                        },
                },
        },
        {
                "NMAC427/guess-indent.nvim",
                config = function()
                        require('guess-indent').setup {}
                end
        },
        {
                "ThePrimeagen/Harpoon",
                config = function()
                        local mark = require("harpoon.mark")
                        local ui = require("harpoon.ui")

                        vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[Ha]rpoon file" })
                        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "[Harpoon] Menu" })

                        vim.keymap.set("n", "<C-h>", function()
                                ui.nav_file(1)
                        end, { desc = "[Harpoon] First file" })
                        vim.keymap.set("n", "<C-j>", function()
                                ui.nav_file(2)
                        end, { desc = "[Harpoon] Second file" })
                        vim.keymap.set("n", "<C-k>", function()
                                ui.nav_file(3)
                        end, { desc = "[Harpoon] Third file" })
                        vim.keymap.set("n", "<C-l>", function()
                                ui.nav_file(4)
                        end, { desc = "[Harpoon] Fourth file" })
                end,
        },
        { -- Collection of various small independent plugins/modules
                "echasnovski/mini.nvim",
                config = function()
                        -- Better Around/Inside textobjects
                        --
                        -- Examples:
                        --  - va)  - [V]isually select [A]round [)]paren
                        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
                        --  - ci'  - [C]hange [I]nside [']quote
                        require("mini.ai").setup({ n_lines = 500 })

                        -- Add/delete/replace surroundings (brackets, quotes, etc.)
                        --
                        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
                        -- - sd'   - [S]urround [D]elete [']quotes
                        -- - sr)'  - [S]urround [R]eplace [)] [']
                        require("mini.surround").setup()

                        require('mini.pairs').setup()

                        -- require('mini.icons').setup()
                        -- require('mini.git').setup()
                        -- require('mini.diff').setup()
                        -- Simple and easy statusline.
                        --  You could remove this setup call if you don't like it,
                        --  and try some other statusline plugin
                        -- local statusline = require("mini.statusline")
                        -- set use_icons to true if you have a Nerd Font
                        -- statusline.setup({ use_icons = true })

                        -- You can configure sections in the statusline by overriding their
                        -- default behavior. For example, here we set the section for
                        -- cursor location to LINE:COLUMN
                        ---@diagnostic disable-next-line: duplicate-set-field
                        -- statusline.section_location = function()
                        --         return "%2l:%-2v"
                        -- end

                        -- require('mini.files').setup()

                        -- vim.keymap.set('n', "<leader>df", MiniFiles.open, { desc = "[F]ile manager" })

                        -- require('mini.indentscope').setup()
                end,
        }
}
