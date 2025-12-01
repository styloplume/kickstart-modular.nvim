-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Oil keymap to view file directory
vim.keymap.set('n', '-', '<cmd>Oil<CR>')

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

-- Source current file
vim.keymap.set('n', '<space>xf', '<cmd>source %<CR>')
-- Source current line
vim.keymap.set('n', '<space>xl', ':.lua<CR>')
-- Source current visual block
vim.keymap.set('v', '<space>xb', ':lua<CR>')

-- Move down/up through the quickfix list
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>')

vim.keymap.set('n', '<leader>tf', '<cmd>PlenaryBustedFile %<CR>')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- NOTE : these lack necessary intelligence to hand things back to wezterm
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
