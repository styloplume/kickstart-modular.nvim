local state = require 'state'

local function load_group(group, check)
  local specs = {}

  for _, name in ipairs(vim.fn.readdir(vim.fn.stdpath 'config' .. '/lua/plugins/' .. group)) do
    if name:match '%.lua$' then
      local mod = 'plugins.' .. group .. '.' .. name:gsub('%.lua$', '')
      local plugin = require(mod)
      if check(name:gsub('%.lua$', '')) then
        table.insert(specs, plugin)
      end
    end
  end

  return specs
end

return require('lazy').setup(
  vim
    .iter({
      load_group('core', function(_)
        return true
      end),
      load_group('extra', function(name)
        return state.enable_extra[name] ~= false
      end),
      load_group('testing', function(name)
        return state.enable_testing[name] == true
      end),
    })
    :flatten()
    :totable(),
  {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
    rocks = {
      enabled = false,
    },
  }
)
