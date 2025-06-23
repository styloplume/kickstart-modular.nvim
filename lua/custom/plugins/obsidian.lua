-- NOTE : the whole rename thing is nice but will pose a pb if directory is opened elsewhere... Hard pass.

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
    -- out of date
    -- 'epwalsh/obsidian.nvim',
    'obsidian-nvim/obsidian.nvim',
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
    },

    opts = {
      -- So instead of trying to detect dir existence, let's just give a list. Need to test @ home.
      workspaces = {
        { name = 'work', path = 'e:/users/' .. os.getenv 'USERNAME' .. '/obsidian' },
        { name = 'home', path = 'd:/users/' .. os.getenv 'USERNAME' .. '/obsidian' },
        { name = 'lost', path = 'c:/users/' .. os.getenv 'USERNAME' .. '/obsidian' },
      },
    },

    log_level = vim.log.levels.INFO,

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Enables completion using nvim_cmp
      nvim_cmp = false,
      -- Enables completion using blink.cmp
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
    -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
    -- way then set 'mappings = {}'.
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context: follow link, show notes with tag, toggle checkbox, or toggle heading fold
      ['<cr>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'.
      -- You may have as many periods in the note ID as you'd like—the ".md" will be added automatically
      local suffix = ''
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix '.md'
    end,
  },
}
