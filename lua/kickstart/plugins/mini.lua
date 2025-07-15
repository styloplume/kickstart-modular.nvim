local load_starter = false

return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim

      if load_starter then
        -- If I'm reading the doc correctly, I should be able to do this
        local starter = require 'mini.starter'

        -- Elaborated config from the doc for testing purposes.
        -- local my_items = {
        --   { name = 'Echo random number', action = 'lua print(math.random())', section = 'Section 1' },
        --   function()
        --     return {
        --       { name = 'Item #1 from function', action = [[echo 'Item #1']], section = 'From function' },
        --       { name = 'Placeholder (always inactive) item', action = '', section = 'From function' },
        --       function()
        --         return {
        --           name = 'Item #1 from double function',
        --           action = [[echo 'Double function']],
        --           section = 'From double function',
        --         }
        --       end,
        --     }
        --   end,
        --   { name = [[Another item in 'Section 1']], action = 'lua print(math.random() + 10)', section = 'Section 1' },
        -- }
        --
        -- local footer_n_seconds = (function()
        --   local timer = vim.uv.new_timer()
        --   local n_seconds = 0
        --   timer:start(
        --     0,
        --     1000,
        --     vim.schedule_wrap(function()
        --       if vim.bo.filetype ~= 'ministarter' then
        --         timer:stop()
        --         return
        --       end
        --       n_seconds = n_seconds + 1
        --       starter.refresh()
        --     end)
        --   )
        --
        --   return function()
        --     return 'Number of seconds since opening: ' .. n_seconds
        --   end
        -- end)()
        --
        -- local hook_top_pad_10 = function(content)
        --   -- Pad from top
        --   for _ = 1, 10 do
        --     -- Insert at start a line with single content unit
        --     table.insert(content, 1, { { type = 'empty', string = '' } })
        --   end
        --   return content
        -- end

        local starter_config = 'startify'

        -- Confir similar to vim-startify
        if starter_config == 'startify' then
          starter.setup {
            evaluate_single = true,
            items = {
              starter.sections.builtin_actions(),
              starter.sections.recent_files(10, false),
              starter.sections.recent_files(10, true),
              -- Use this if you set up 'mini.sessions'
              starter.sections.sessions(5, true),
            },
            content_hooks = {
              starter.gen_hook.adding_bullet(),
              starter.gen_hook.indexing('all', { 'Builtin actions' }),
              -- starter.gen_hook.padding(3, 2),
              starter.gen_hook.aligning('center', 'center'),
            },
          }
        end

        -- Config similar to dashboard-nvim
        if starter_config == 'dashboard' then
          starter.setup {
            items = {
              starter.sections.telescope(),
            },
            content_hooks = {
              starter.gen_hook.adding_bullet(),
              starter.gen_hook.aligning('center', 'center'),
            },
          }
        end

        -- Elaborated config from the doc for testing purposes.
        -- starter.setup {
        --   items = my_items,
        --   footer = footer_n_seconds,
        --   content_hooks = { hook_top_pad_10 },
        -- }

        if starter_config == 'default' then
          starter.setup()
        end
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
