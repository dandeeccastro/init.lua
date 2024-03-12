local luasnip = require('luasnip')

local snippet = luasnip.snippet
local text_node = luasnip.text_node
local choice_node = luasnip.choice_node
local insert_node = luasnip.insert_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

vim.keymap.set({ 'i', 's' }, '<C-j>', function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true})

vim.keymap.set({ 'i', 's' }, '<C-k>', function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true})

vim.keymap.set({ 'i', 's' }, '<C-n>', function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end)

luasnip.add_snippets('javascript', {
    snippet('plghandle', fmt([[
    exports.handle = async (plg, event) => {
      []
    };
    ]], { insert_node(1) }, { delimiters = '[]'})),

    snippet('plgaxios', fmt([[
    plg.axios({
      method: '[]',
      url: [],
      params: {[]},
      data: {[]},
    });
    ]], { choice_node(1, {
        text_node("GET"),
        text_node("POST"),
        text_node("PUT"),
        text_node("DELETE"),
        text_node("OPTIONS"),
    }), insert_node(2), insert_node(3), insert_node(4)  },
    { delimiters = '[]'})),

    snippet('plgtest', fmt([[
    const plg = require('pluga-plg');
    const { expect } = require('chai');

    const [] = require('../../lib/[]s/[]');

    const event = {
      meta: {
        baseURI: process.env.BASE_URI,
      },
      auth: {
        access_token: process.env.access_token,
      },
      input: {[]},
    };

    describe('[]', () => {
      []
    })
    ]], {
        choice_node(1, {
            text_node('trigger'),
            text_node('action'),
        }),
        rep(1),
        insert_node(2),
        insert_node(3),
        insert_node(4),
        insert_node(5),
    }, { delimiters = '[]'})),

    snippet('plgmeta', fmt([[
    exports.metaConfig = {
      name: {
        pt_BR: '<>',
        en: '<>',
      },
      description: {
        pt_BR: '<>',
        en: '<>',
      },
      configuration_fields: {
        <>,
      },
      <>_fields: {
        type: 'local',
        fields: [
          <>
        ],
      },
    };
    ]], {
        insert_node(1),
        insert_node(2),
        insert_node(3),
        insert_node(4),
        insert_node(5),
        choice_node(6, {
            text_node('trigger'),
            text_node('action'),
        }),
        insert_node(7),
    }, { delimiters = '<>'})),
})
