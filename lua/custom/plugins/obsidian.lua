local function getWorkspaces()
  local retval = {}

  local possible_workspaces = {
    'e:/users/' .. os.getenv 'USERNAME' .. '/obsidian',
    'd:/users/' .. os.getenv 'USERNAME' .. '/obsidian',
    'c:/users/' .. os.getenv 'USERNAME' .. '/obsidian',
  }

  for i = 1, #possible_workspaces do
    local ws_path = possible_workspaces[i]
    local exists, errmsg = os.rename(ws_path, ws_path)

    if exists then
      table.insert(retval, { name = ws_path, path = ws_path })
    end
  end

  return retval
end

return {
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = false,
    ft = 'markdown',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = getWorkspaces(),
      -- see below for full list of options 👇
    },
  },
}
