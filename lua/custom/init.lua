-- This is where I put random settings to avoid merges with kickstart files.

-- How about making this return a module with functions ?
local module = {}
-- To be filled by root init.lua - table containing key/values such as <plugin> = bool
module.plugins = {}

function module.Setup()
  vim.o.conceallevel = 1

  -- Force use of clang to build stuff
  require('nvim-treesitter.install').compilers = { 'clang', 'gcc' }

  --------------------------------------------------------------------------------------------
  --                                  Advent of neovim                                      --
  --------------------------------------------------------------------------------------------

  -- We have vim-sleuth going, have to play around with this.
  -- vim.opt.shiftwidth = 4

  -- Highlight builtin functions with a specific color
  -- vim.cmd [[hi @function.builtin guifg=yellow]]

  -- Source current file (conflicts with <lead><lead> to telescope current buffers)
  vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')
  -- Source current line
  vim.keymap.set('n', '<space>x', ':.lua<CR>')
  -- Source current visual block
  vim.keymap.set('v', '<space>x', ':lua<CR>')

  -- Oil keymap to view file directory
  vim.keymap.set('n', '-', '<cmd>Oil<CR>')

  -- Move down/up through the quickfix list
  vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>')
  vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>')

  -- NOTE:
  -- - from telescope window, ctrl-q will switch result to quickfix
  -- - :cclose and :copen allow to hide/show quickfix (so does <lead>q)
  -- - :cdo allows to run something onto the quickfix files only (I think?)
  --   example : :cdo s/client/whatever/gc to globally substitute a string while asking
  --   for confirmation everytime.
  -- - :help :substitute !
  --
  -- NOTE:
  -- - ctrl-w hjkl to move windows, (kickstart maps these to ctrl+hjkl)
  -- - ctrl-w chained to cycle through windows
  -- - ctrl-w T to move window to new tab
  -- - gt to cycle through tabs
  -- - also setqflist is a way to put custom stuff in a qf list.

  -- I believe these are new defaults in 0.11, so I added them manually while @ 0.10
  vim.keymap.set('n', 'grn', vim.lsp.buf.rename) -- also <lead>rn
  vim.keymap.set('n', 'gra', vim.lsp.buf.code_action) -- also <lead>ra
  vim.keymap.set('n', 'grr', vim.lsp.buf.references) -- 'gr' => telescope.lsp_references

  -- Playing with autocmd and jobs

  -- vim.api.nvim_create_user_command(a, b, c)

  -- Turn off numbers upon entering terminal
  vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
      vim.opt.number = false
      vim.opt.relativenumber = false
    end,
  })

  -- Start a terminal with a job id
  local job_id = 0

  vim.keymap.set('n', '<space>st', function()
    vim.cmd.vnew() -- new vertical thing
    vim.cmd.term() -- with a terminal
    vim.cmd.wincmd 'J' -- at the bottom
    vim.api.nvim_win_set_height(0, 15)

    -- vim.api.nvim_open_win(...) (check help) to open a floating term instead

    job_id = vim.bo.channel
  end)

  -- Send instruction to terminal through job id
  vim.keymap.set('n', '<space>example', function()
    -- make
    -- go build, go test ./whatever
    vim.fn.chansend(job_id, { 'ls -al\r\n' })
  end)

  --------------------------------------------------------------------------------------------
  --                                         Other                                          --
  --------------------------------------------------------------------------------------------

  local custom = require 'custom'
  local load_it = custom.plugins['harpoon']
  if load_it ~= nil and load_it then
    -- Harpoon config (copied from github)
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    -- TODO : look @ doc to define keybinds
  end
end

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

return module
