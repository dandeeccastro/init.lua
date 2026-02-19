-- WARN: Para trabalho somente
return {
        -- FIXME: instalar um provider de IA que encaixe nessa porra aqui
        'ThePrimeagen/99',
        config = function()
                local _99 = require('99')
                local cwd = vim.uv.cwd()
                local basename = vim.fs.basename(cwd)

                _99.setup()

                vim.keymap.set('v', '<leader>9v', function()
                        _99.visual()
                end)

                vim.keymap.set('n', '<leader>9x', function()
                        _99.stop_all_requests()
                end)

                vim.keymap.set('n', '<leader>9s', function()
                        _99.search()
                end)
        end
}
