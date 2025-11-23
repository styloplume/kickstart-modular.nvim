-- TODO : rename and gitignore. This belongs at work only.

-- This must contain the path to <plugin>.nvim
local plugin_path = '<path_to_my_plugin>'

if vim.uv.fs_stat(plugin_path) then
  return {
    {
      dir = plugin_path,
      config = function()
        require('my_plugin').setup {
          -- your config here
        }
      end,
    },
  }
end

-- default empty table
return { {} }
