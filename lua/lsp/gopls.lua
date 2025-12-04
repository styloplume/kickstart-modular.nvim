local M = {}

function M.setup(defaults)
  -- Configure LSP
  vim.lsp.config('gopls', {
    -- Shared defaults (experimental)
    capabilities = defaults.capabilities,
    on_attach = defaults.on_attach,
    -- Server-specific settings. See `:help lsp-quickstart`
  })

  -- Enable LSP
  vim.lsp.enable 'gopls'
end

return M
