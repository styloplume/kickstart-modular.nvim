-- TODO : pcall(require, "work") to detect if work vs home.
-- home : use codestral.
-- work : use work.bring_ai()

local plugin = { {} }
local custom = require 'custom'
local load_it = custom.plugins['minuet']
if load_it ~= nil and load_it then
  plugin = {
    {
      'milanglacier/minuet-ai.nvim',
      config = function()
        require('minuet').setup {
          -- Your configuration options here
          -- Because I want to stick to blink, I will not :
          -- * configure virtual text
          -- * built-in completion, mini, or LSP
          provider = 'codestral',
          auto_space = true,
          provider_options = {
            codestral = {
              model = 'codestral-latest',
              fim = true,
              optional = {
                temperature = 0.0,
                max_tokens = 128,
                stop = { '\n\n' },
              },
            },
          },
        }
      end,
    },
    -- requires plenary but already installed as dep of other plugin so all good.
    { 'nvim-lua/plenary.nvim' },
    -- blink optional but also installed so we'll set it up there.
  }
end

return plugin
