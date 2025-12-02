local M = {}

M.capabilities = require('blink-cmp').get_lsp_capabilities()

function M.on_attach(client, bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr }

  map('n', 'K', vim.lsp.buf.hover, opts)
  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'gr', vim.lsp.buf.references, opts)
  map('n', '<leader>rn', vim.lsp.buf.rename, opts)
end

return M
