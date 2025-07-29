local plugin = { {} }
local custom = require 'custom'
local load_it = custom.plugins['harpoon']
if load_it ~= nil and load_it then
  plugin = {
    {
      'ThePrimeagen/harpoon',
      branch = 'harpoon2',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
  }
end

return plugin
