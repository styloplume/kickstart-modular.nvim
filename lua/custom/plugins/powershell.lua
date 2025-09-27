local plugin = { {} }
local custom = require 'custom'
local load_it = custom.plugins['powershell']
if load_it ~= nil and load_it then
  plugin = {
    {
      'TheLeoP/powershell.nvim',
      ---@type powershell.user_config
      opts = {
        bundle_path = vim.fn.stdpath 'data' .. '/mason/packages/powershell-editor-services',
      },
    },
  }
end

return plugin
