-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local plugins = {}

table.insert(plugins, {
  'S1M0N38/love2d.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    { '<leader>v', ft = 'lua', desc = 'LÖVE' },
    { '<leader>vv', '<cmd>LoveRun<cr>', ft = 'lua', desc = 'Run LÖVE' },
    { '<leader>vs', '<cmd>LoveStop<cr>', ft = 'lua', desc = 'Stop LÖVE' },
  },
})

if vim.tbl_isempty(plugins) then
  table.insert(plugins, {})
end

return plugins
