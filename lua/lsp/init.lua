local defaults = require 'utils.lsp'

-- TODO : parse other files in dir for auto load.
local servers = {
  'rust',
  'lua_ls',
  'python',
  'clangd',
}

for _, name in ipairs(servers) do
  require('lsp.' .. name).setup(defaults)
end
