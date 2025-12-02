local M = {}

function M.setup(defaults)
  -- Configure LSP
  vim.lsp.config('clangd', {
    -- Shared defaults (experimental)
    capabilities = defaults.capabilities,
    on_attach = defaults.on_attach,
    -- Server-specific settings. See `:help lsp-quickstart`
    cmd = {
      'clangd',
      '--clang-tidy',
    },
  })

  -- Enable LSP
  vim.lsp.enable 'clangd'
end

return M
