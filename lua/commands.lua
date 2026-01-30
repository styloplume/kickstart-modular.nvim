-- Quickly turn on/off log levels
vim.api.nvim_create_user_command('LogLevelDEBUG', function()
  vim.lsp.log.set_level(vim.log.levels.DEBUG)
end, {})
vim.api.nvim_create_user_command('LogLevelOFF', function()
  vim.lsp.log.set_level(vim.log.levels.OFF)
end, {})
vim.keymap.set('n', '<leader>l0', '<cmd>LogLevelOFF<CR>')
vim.keymap.set('n', '<leader>l5', '<cmd>LogLevelDEBUG<CR>')

-- Let's fix CRLF when needed
vim.api.nvim_create_user_command('FixCRLF', function()
  -- Set buffer to LF
  vim.opt_local.fileformat = 'unix'

  -- Remove DOS carriage returns
  vim.cmd [[%s/\r$//e]]

  -- Save file
  vim.cmd 'write'
end, {})

-- And force CRLF when it makes sense
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'bash', 'zsh', 'awk', 'python' },
  callback = function()
    vim.opt_local.fileformat = 'unix'
  end,
})

-- Turn off numbers upon entering terminal
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Because 0.12 offers built LSP api while not entirely replacing nvim-lspconfig's stuff,
-- we have to redefine some things for comfort.

vim.api.nvim_create_user_command('LspInfo', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr }

  if #clients == 0 then
    vim.notify('No LSP clients attached to current buffer', vim.log.levels.INFO)
    return
  end

  local lines = {}

  for _, c in ipairs(clients) do
    lines[#lines + 1] = string.format('%s (id=%d)', c.name, c.id)

    lines[#lines + 1] = '  root: ' .. (c.config.root_dir or 'nil')
    lines[#lines + 1] = '  filetypes: ' .. table.concat(c.config.filetypes or {}, ', ')

    local enc = c.offset_encoding
    if type(enc) == 'table' then
      enc = table.concat(enc, ', ')
    elseif type(enc) ~= 'string' then
      enc = 'unknown'
    end
    lines[#lines + 1] = '  offsetEncoding: ' .. enc

    -- rest unchanged
  end

  -- Display in a scratch buffer
  vim.lsp.util.open_floating_preview(lines, 'markdown', { border = 'rounded' })
end, {})
