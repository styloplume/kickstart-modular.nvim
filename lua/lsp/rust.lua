local M = {}

-- NOTE : rust-analyzer installed with rustup add component rust-analyzer

function M.setup(defaults)
  -- Configure LSP
  vim.lsp.config('rust_analyzer', {
    -- Shared defaults (experimental)
    capabilities = defaults.capabilities,
    on_attach = defaults.on_attach,
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

  -- Enable LSP
  vim.lsp.enable 'rust_analyzer'
end

return M
