-- NOTE: So I need to develop a plugin for work.
-- I do not want any work-related info to appear in my (github) config,
-- so I will rely on the definition of some variable to do this.

-- Derived from https://github.com/Donearm/scripts/blob/master/lib/basename.lua
-- Function equivalent to basename in POSIX systems
--@param str the path string
--@param ext the extension to remove
function Basename(str, ext)
  local name = string.gsub(str, '(.*/)(.*)', '%2')
  if ext ~= '' then
    name = string.gsub(name, '.' .. ext, '')
  end
  return name
end

-- This must contain the path to <plugin>.nvim
local nvim_work_plugin_path = os.getenv 'NVIM_WORK_PLUGIN'

if nvim_work_plugin_path then
  -- Should it be a Windows path, replace \ with /
  nvim_work_plugin_path = string.gsub(nvim_work_plugin_path, '\\', '/')
  -- Get the name without .nvim
  local nvim_work_plugin_name = Basename(nvim_work_plugin_path, 'nvim')
  -- Load the plugin
  return {
    {
      dir = nvim_work_plugin_path,
      config = function()
        require(nvim_work_plugin_name)
      end,
    },
  }
end

-- default empty table
return { {} }
