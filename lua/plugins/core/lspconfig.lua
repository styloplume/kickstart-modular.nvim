-- NOTE :
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

-- NOTE : about Lazy loading
-- { 'plugin', opts = {} } calls setup()
-- { 'plugin' } does not call setup()

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP.
      'saghen/blink.cmp', -- Allows extra capabilities provided by blink.cmp
    },
    config = function()
      ---------------------------------------------
      -- Mason Setup
      ---------------------------------------------
      require('mason').setup {
        -- registries = {
        --   'github:mason-org/mason-registry', -- keep the official registry
        -- },
        -- providers = {
        --   'node', -- keep only the providers you actually want
        --   'npm',
        --   'python',
        --   'pip',
        --   'cargo',
        --   'python venv',
        -- },
      }
      require('mason-lspconfig').setup {
        auto_install = true,
      }
      require('mason-tool-installer').setup {
        -- ensure formatters are installed for conform
        -- investigate mason-conform.nvim for autoinstall
        ensure_installed = {
          'gopls',
          'sqlfluff',
          'prettier',
          'stylua',
          'bashls',
          'shfmt', -- dont forget shellcheck via scoop if no tar
          'powershell-editor-services',
        },
        auto_update = false,
      }

      -------------------------------------------------------
      -- LSPAttach: keymaps, LSP behaviors, cursor highlight
      -------------------------------------------------------
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Inlay hints
          if client and client.server_capabilities.inlayHintProvider then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
                bufnr = bufnr,
              })
            end, 'Toggle Inlay Hints')
          end

          -- Cursor highlight (document_highlight)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      ---------------------------------------
      -- Global diagnostics
      ---------------------------------------

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          current_line = true,
          -- virt_text_pos = 'right_align',
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
