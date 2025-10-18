return {
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
}
