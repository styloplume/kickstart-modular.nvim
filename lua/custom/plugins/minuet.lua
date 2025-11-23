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
          virtualtext = {
            auto_trigger_ft = { 'lua' },
            keymap = {
              -- accept whole completion
              accept = '<A-A>',
              -- accept one line
              accept_line = '<A-a>',
              -- accept n lines (prompts for number)
              -- e.g. "A-z 2 CR" will accept 2 lines
              accept_n_lines = '<A-z>',
              -- Cycle to prev completion item, or manually invoke completion
              prev = '<A-[>',
              -- Cycle to next completion item, or manually invoke completion
              next = '<A-]>',
              dismiss = '<A-e>',
            },
          },
          lsp = {
            enabled_ft = { 'lua' }, --, 'toml','cpp' },
            -- Enables automatic completion triggering using `vim.lsp.completion.enable`
            enabled_auto_trigger_ft = { 'lua' }, -- 'cpp' },
          },
        }
      end,
    },
    { 'nvim-lua/plenary.nvim' },
    -- optional, if you are using virtual-text frontend, blink is not required.
    {
      'Saghen/blink.cmp',
      config = function()
        require('blink-cmp').setup {
          keymap = {
            -- Manually invoke minuet completion.
            ['<A-y>'] = require('minuet').make_blink_map(),
          },
          sources = {
            -- Enable minuet for autocomplete
            default = { 'lsp', 'path', 'buffer', 'snippets', 'minuet' },
            -- For manual completion only, remove 'minuet' from default
            providers = {
              minuet = {
                name = 'minuet',
                module = 'minuet.blink',
                async = true,
                -- Should match minuet.config.request_timeout * 1000,
                -- since minuet.config.request_timeout is in seconds
                timeout_ms = 3000,
                score_offset = 50, -- Gives minuet higher priority among suggestions
              },
            },
          },
          -- Recommended to avoid unnecessary request
          completion = { trigger = { prefetch_on_insert = false } },
        }
      end,
    },
  }
end

return plugin
