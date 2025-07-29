local custom = require 'custom'

local plugin = { {} }

if custom.harpoon then
  plugin = {
    {
      'ThePrimeagen/harpoon',
      branch = 'harpoon2',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
  }
end

return plugin
