local defaults = require 'utils.lsp'

-- Load all non-init.lua files in this directory
for _, name in ipairs(vim.fn.readdir(vim.fn.stdpath 'config' .. '/lua/lsp/')) do
  if name:match '%.lua$' and not name:match 'init.lua' then
    local mod = 'lsp.' .. name:gsub('%.lua$', '')
    require(mod).setup(defaults)
  end
end
