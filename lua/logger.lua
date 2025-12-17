local M = {}

-- Change this once if you want
local logfile = vim.fn.stdpath 'cache' .. '/myconfig.log'

local function write(line)
  local f = io.open(logfile, 'a')
  if not f then
    return
  end
  f:write(line .. '\n')
  f:close()
end

local function fmt(...)
  local parts = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    parts[#parts + 1] = type(v) == 'string' and v or vim.inspect(v)
  end
  return table.concat(parts, ' ')
end

function M.log(...)
  write(os.date '%H:%M:%S ' .. fmt(...))
end

function M.clear()
  local f = io.open(logfile, 'w')
  if f then
    f:close()
  end
end

function M.path()
  return logfile
end

vim.api.nvim_create_user_command('ConfigLog', function()
  vim.cmd('edit ' .. M.path())
end, {})

return M
