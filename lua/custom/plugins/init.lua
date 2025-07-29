-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local plugins = {}

local custom = require 'custom'
local load_it = nil

load_it = custom.plugins['overseer']
if load_it ~= nil and load_it then
  table.insert(plugins, { 'stevearc/overseer.nvim', opts = {} })
end

load_it = custom.plugins['toggleterm']
if load_it ~= nil and load_it then
  table.insert(plugins, { 'akinsho/toggleterm.nvim', version = '*', config = true })
end

load_it = custom.plugins['vimbegood']
if load_it ~= nil and load_it then
  table.insert(plugins, { 'ThePrimeagen/vim-be-good' })
end

load_it = custom.plugins['zenmode']
if load_it ~= nil and load_it then
  table.insert(plugins, { 'folke/zen-mode.nvim', opts = {} })
end

load_it = custom.plugins['love2d']
if load_it ~= nil and load_it then
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
