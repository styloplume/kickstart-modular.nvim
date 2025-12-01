local module = {}

-- Importing base64/set_user_var from folke/dot/nvim/lua/util/init.lua
-- to define IS_NVIM user var for wezterm's panes to pass keys to nvim.
---@param data string
function module.base64(data)
  data = tostring(data)
  local bit = require 'bit'
  local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  local b64, len = '', #data
  for i = 1, len, 3 do
    local a, b, c = data:byte(i, i + 2)
    local buffer = bit.bor(bit.lshift(a, 16), bit.lshift(b or 0, 8), c or 0)
    for j = 0, 3 do
      local index = bit.rshift(buffer, (3 - j) * 6) % 64
      b64 = b64 .. b64chars:sub(index + 1, index + 1)
    end
  end
  local padding = (3 - len % 3) % 3
  b64 = b64:sub(1, -1 - padding) .. ('='):rep(padding)
  return b64
end

function module.set_user_var(key, value)
  io.write(string.format('\027]1337;SetUserVar=%s=%s\a', key, module.base64(value)))
end

function module.wezterm()
  local nav = {
    h = 'Left',
    j = 'Down',
    k = 'Up',
    l = 'Right',
  }

  local function navigate(dir)
    return function()
      local win = vim.api.nvim_get_current_win()
      vim.cmd.wincmd(dir)
      local pane = vim.env.WEZTERM_PANE
      if vim.system and pane and win == vim.api.nvim_get_current_win() then
        local pane_dir = nav[dir]
        vim.system({ 'wezterm', 'cli', 'activate-pane-direction', pane_dir }, { text = true }, function(p)
          if p.code ~= 0 then
            vim.notify('Failed to move to pane ' .. pane_dir .. '\n' .. p.stderr, vim.log.levels.ERROR, { title = 'Wezterm' })
          end
        end)
      end
    end
  end

  -- When loading nvim, tell wezterm we're here.
  module.set_user_var('IS_NVIM', true)
  -- Also tell wezterm we're leaving.
  vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
      module.set_user_var('IS_NVIM', false)
    end,
  })
  -- Allows seamless pane movement with or without nvim.

  -- Move to window using the movement keys
  for key, dir in pairs(nav) do
    vim.keymap.set('n', '<' .. dir .. '>', navigate(key), { desc = 'Go to ' .. dir .. ' window' })
    vim.keymap.set('n', '<C-' .. key .. '>', navigate(key), { desc = 'Go to ' .. dir .. ' window' })
  end
end

return module
