local M = {}

function M.setup(defaults)
  -- Configure LSP
  vim.lsp.config('lua_ls', {
    -- Shared defaults (experimental)
    capabilities = defaults.capabilities,
    on_attach = defaults.on_attach,
    -- Server-specific settings. See `:help lsp-quickstart`
    -- cmd = { ... },
    -- filetypes = { ... },
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
        diagnostics = {
          -- Tell LSP vim is ok as global
          globals = { 'vim' },
        },
      },
    },
  })

  -- Enable LSP
  vim.lsp.enable 'lua_ls'
end

return M
