local M = {}

local blink_caps = require('blink.cmp').get_lsp_capabilities()

---@class ExtendedCapabilities: lsp.ClientCapabilities
local caps = vim.tbl_deep_extend('force', {}, blink_caps, {
  offsetEncoding = { 'utf-8' },
})

M.capabilities = caps

function M.on_attach(client, bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr }

  map('n', 'K', vim.lsp.buf.hover, opts)
  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'gr', vim.lsp.buf.references, opts)
  map('n', '<leader>rn', vim.lsp.buf.rename, opts)
end

return M
