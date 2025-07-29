-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local custom = require 'custom'

local plugins = {}

if custom.overseer then
  table.insert(plugins, { 'stevearc/overseer.nvim', opts = {} })
end

if custom.toggleterm then
  table.insert(plugins, { 'akinsho/toggleterm.nvim', version = '*', config = true })
end

if custom.vimbegood then
  table.insert(plugins, { 'ThePrimeagen/vim-be-good' })
end

if custom.zenmode then
  table.insert(plugins, { 'folke/zen-mode.nvim', opts = {} })
end

if custom.love2d then
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
end

if vim.tbl_isempty(plugins) then
  table.insert(plugins, {})
end

return plugins
