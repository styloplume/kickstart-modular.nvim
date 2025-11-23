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
          cmp = {
            enable_auto_complete = false,
          },
          blink = {
            enable_auto_complete = false,
          },
          virtualtext = {
            auto_trigger_ft = {},
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
            enabled_ft = {},
            -- Enables automatic completion triggering using `vim.lsp.completion.enable`
            enabled_auto_trigger_ft = {},
          },
          provider_options = {
            codestral = {
              optional = {
                max_tokens = 256,
                stop = { '\n\n' },
              },
            },
          },
        }
      end,
    },
    { 'nvim-lua/plenary.nvim' },
  }
end

return plugin
