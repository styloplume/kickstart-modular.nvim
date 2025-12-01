-- TODO : user cmd + keymap to turn this on/off, maybe <leader>l1..n, just an idea.
-- Quickly turn logging ON or OFF (should be some kind of keybind)
vim.lsp.log.set_level(vim.log.levels.OFF)

-- TODO : move to lsp subdir and migrate lua_ls/clangd to vim.lsp.*
-- configure rust analyzer (installed with rustup add component rust-analyzer)
vim.lsp.config('rust_analyzer', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    ['rust-analyzer'] = {
      completion = {
        callable = {
          snippets = 'add_parentheses',
        },
      },
    },
  },
})
-- enable rust analyzer
vim.lsp.enable 'rust_analyzer'

-- Tell wezterm we're here
require('wezterm').wezterm()

-- [[ Setting options ]]
require 'options'

-- [[ Commands ]]
require 'commands'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'plugins'

-- [[ Custom settings ]]
require('custom').Setup()

--
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
