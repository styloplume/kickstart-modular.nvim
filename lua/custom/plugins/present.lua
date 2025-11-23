local plugin_path = 'd:/projects/plugins/present.nvim'

if vim.uv.fs_stat(plugin_path) then
  return {
    {
      dir = plugin_path,
      config = function()
        require 'present'
      end,
    },
  }
end

return { {} }
