local M = {}

function M.setup(defaults)
  -- Configure LSP
  vim.lsp.config('pyright', {
    -- Shared defaults (experimental)
    capabilities = defaults.capabilities,
    on_attach = defaults.on_attach,
    -- Server-specific settings. See `:help lsp-quickstart`
  })
  vim.lsp.config('ruff', {
    -- Shared defaults (experimental)
    capabilities = defaults.capabilities,
    on_attach = defaults.on_attach,
    -- Server-specific settings. See `:help lsp-quickstart`
  })

  -- Enable LSP
  vim.lsp.enable 'pyright'
  vim.lsp.enable 'ruff'
end

return M
