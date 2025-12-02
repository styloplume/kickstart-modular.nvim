require 'wezterm'
require 'options'
require 'commands'
require 'keymaps'
require 'plugins'
require 'lsp'

-- TODO : find a home for this -- Force use of clang to build stuff
require('nvim-treesitter.install').compilers = { 'clang', 'gcc' }

--
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
