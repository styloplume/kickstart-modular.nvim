local plugin = { {} }
local custom = require 'custom'
local load_it = custom.plugins['vimtex']
if load_it ~= nil and load_it then
  plugin = {
    {
      'lervag/vimtex',
      lazy = false, -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_general_viewer = 'SumatraPDF'
        vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
      end,
      -- NOTE : necessitates npm install -g tree-sitter-cli to build latex LSP --
    },
  }
end

return plugin
