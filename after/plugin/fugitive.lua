vim.keymap.set('n', '<leader>gg', vim.cmd.Git, { desc = '[G]it [G]ud' }) -- tem que ter um jeito melhor...

local dandeeccastro_fugitive = vim.api.nvim_create_augroup("dandeeccastro_fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = dandeeccastro_fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = {buffer = bufnr, remap = false}

        vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git('push')
        end, { buffer = bufnr, remap = false, desc = '[Git] [p]ush'})

        vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git('pull')
        end, { buffer = bufnr, remap = false, desc = '[Git] [P]ull'})

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", { buffer = bufnr, remap = false, desc = '[Git] push -u origin ___'});
    end,
})

