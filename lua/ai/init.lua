-- TODO : local config = require("whatever.config")
local logger = require 'logger'
local providers = require 'ai.providers'
local ts = require 'ai.ts'

---@class AIProvider
---@field name string
---@field default_model string
---@field api_key_env string
---@field build_request fun(opts: table): table
---@field parse_response fun(resp: table): string

-- Example codestral curl request for FIM :
-- curl --location 'https://api.mistral.ai/v1/fim/completions' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header "Authorization: Bearer $MISTRAL_API_KEY" \
--data '{
--     "model": "codestral-latest",
--     "prompt": "def fibonacci(n: int):",
--     "suffix": "n = int(input('Enter a number: '))\nprint(fibonacci(n))",
--     "max_tokens": 64,
--     "temperature": 0
-- }' -- suffix "optional", can be used for pure completion without one.
-- also "stop" tokens available to stop generation when it generates specific strings.
-- "stop": ["return"] for example.

-- Chat completion example request :
-- curl --location "https://api.mistral.ai/v1/chat/completions" \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header "Authorization: Bearer $MISTRAL_API_KEY" \
--data '{
--   "model": "codestral-latest",
--   "messages": [{"role": "user", "content": "Write a function for fibonacci"}]
-- }'
--
-- again, refer to https://docs.mistral.ai/capabilities/code_generation for more info.

local M = {}

-- Make this part independent of work plugin to move it to config.
-- Work plugin should only have to feed its providers.

local default_config = {
  provider = 'codestral', -- or "openai", "mistral"
  model = 'codestral-2501',
  temperature = 0.2,
  max_tokens = 256, -- min_tokens also available (codestral)
}
local runtime_config = vim.deepcopy(default_config)

-- TODO : make this part better through setup() impl.

function M.set(opts)
  runtime_config = vim.tbl_deep_extend('force', default_config, opts or {})
end

local shared_context = {
  ns = vim.api.nvim_create_namespace 'ai',
  extmark = nil,
  suggestion = nil,
}

----------------------------------------------------------------------
-- Context helpers
----------------------------------------------------------------------

local function cursor_context(max_lines)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local start = math.max(0, row - max_lines)
  local lines = vim.api.nvim_buf_get_lines(0, start, row + 1, false)
  lines[#lines] = string.sub(lines[#lines], 1, col)

  return table.concat(lines, '\n')
end

---
---
---

local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

----------------------------------------------------------------------
-- Virtual text completion
----------------------------------------------------------------------

local function clear_completion()
  if shared_context.extmark then
    vim.api.nvim_buf_del_extmark(0, shared_context.ns, shared_context.extmark)
  end
  shared_context.extmark = nil
  shared_context.suggestion = nil
end

local function show_completion(text)
  clear_completion()

  -- to trim trailing newline/avoid blank ghost line :
  -- text = text:gsub("\n$", "")
  text = vim.trim(text)
  if text == '' then
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local lines = vim.split(text, '\n', { plain = true })

  shared_context.extmark = vim.api.nvim_buf_set_extmark(0, shared_context.ns, row, col, {
    virt_lines = vim.tbl_map(function(line)
      return { { line, 'Comment' } }
    end, lines),
    virt_lines_above = false,
  })

  shared_context.suggestion = text
end

local function accept_completion()
  if not shared_context.suggestion then
    return
  end

  -- old version
  -- local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- row = row - 1
  -- vim.api.nvim_buf_set_text(0, row, col, row, col, vim.split(context.suggestion, '\n'))
  -- new version
  -- vim.api.nvim_put({ shared_context.suggestion }, 'c', true, true)

  -- normalize text
  local text = shared_context.suggestion:gsub('\n$', '')

  -- split to lines
  local lines = vim.split(text, '\n', { plain = true })

  logger.log(lines)

  -- insert
  vim.api.nvim_put(lines, 'c', true, true)

  clear_completion()
end

----------------------------------------------------------------------
-- Public actions
----------------------------------------------------------------------

function M.complete()
  logger.log 'Complete...'

  local node = ts.extract()

  local prefix = node and ts.node_text_upto_cursor(node) or cursor_context(20)

  local payload = {
    model = runtime_config.model or 'codestral-2501',
    prompt = prefix,
    suffix = '',
    max_tokens = runtime_config.max_tokens or 256,
  }

  logger.log('payload:', payload)

  local provider = providers.get 'codestral'
  local res, err = provider.request('/fim/completions', payload)

  logger.log('res:', res)
  logger.log('err:', err)

  if not res then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  if res.detail then
    vim.notify(res.detail, vim.log.levels.ERROR)
    return
  end

  local text = res.choices and res.choices[1] and res.choices[1].message.content
  if not text or text == '' then
    return
  end

  logger.log('text: ' .. text)

  show_completion(text)
end

function M.prompt(input)
  local payload = {
    model = runtime_config.model or 'codestral-2501',
    messages = {
      { role = 'system', content = runtime_config.system_prompt },
      { role = 'user', content = input },
    },
  }

  local provider = providers.get 'codestral'
  local res, err = provider.request('/chat/completions', payload)

  if not res then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  local text = res.choices[1].message.content
  vim.notify(text, vim.log.levels.INFO)
end

----------------------------------------------------------------------
-- Setup hooks (called from init.lua)
----------------------------------------------------------------------

function M.setup_commands()
  vim.api.nvim_create_user_command('AIComplete', M.complete, {})

  vim.api.nvim_create_user_command('AIPrompt', M.prompt, { nargs = '*' })

  vim.keymap.set('i', '<C-l>', accept_completion, { desc = 'Accept AI completion' })
end

-- vim.api.nvim_create_autocmd({ 'CursorMovedI', 'InsertLeave' }, {
--   callback = function()
--     M.clear_completion()
--   end,
-- })

return M
