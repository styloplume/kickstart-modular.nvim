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
