local ts = require 'ai.ts'

---@class AIProvider
---@field name string
---@field default_model string
---@field api_key_env string
---@field build_request fun(opts: table): table
---@field parse_response fun(resp: table): string

local providers = {
  openai = require 'ai.providers.openai',
  mistral = require 'ai.providers.mistral',
}

local M = {}

-- Make this part independent of work plugin to move it to config.
-- Work plugin should only have to feed its providers.

local default = {
  config = {
    provider = 'openai', -- "openai" | "mistral"
    model = nil, -- nil = provider default
    temperature = 0.1,
    max_tokens = 256,
  },
  context = {
    ns = vim.api.nvim_create_namespace 'ai',
    extmark = nil,
    suggestion = nil,
  },
}

local runtime = vim.deepcopy(default)
local config = runtime.config
local context = runtime.context

-- TODO : make this part better through setup() impl.

function M.set(opts)
  runtime = vim.tbl_deep_extend('force', default, opts or {})
end

----------------------------------------------------------------------
-- Provider resolution
----------------------------------------------------------------------

local function get_provider()
  local name = config.runtime.ai.provider
  local p = providers[name]
  if not p then
    error('Unknown AI provider: ' .. tostring(name))
  end
  return p
end

----------------------------------------------------------------------
-- Context helpers
----------------------------------------------------------------------

local function buffer_text()
  return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
end

local function cursor_context(max_lines)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local start = math.max(0, row - max_lines)
  local lines = vim.api.nvim_buf_get_lines(0, start, row + 1, false)
  lines[#lines] = string.sub(lines[#lines], 1, col)

  return table.concat(lines, '\n')
end

local function context_for_completion()
  local node = ts.extract()

  if node then
    return ts.node_text_upto_cursor(node)
  end

  -- fallback if TS unavailable
  return cursor_context(20)
end

----------------------------------------------------------------------
-- Low-level request dispatcher (provider-agnostic)
----------------------------------------------------------------------

local function dispatch(messages, on_result)
  local ai = config.runtime.ai
  local provider = get_provider()

  local api_key = os.getenv(provider.api_key_env)
  if not api_key then
    vim.notify('Missing API key: ' .. provider.api_key_env, vim.log.levels.ERROR)
    return
  end

  local req = provider.build_request {
    api_key = api_key,
    model = ai.model,
    messages = messages,
    temperature = ai.temperature,
    max_tokens = ai.max_tokens,
  }

  local payload = vim.fn.json_encode(req.body)

  local cmd = {
    'curl',
    '-s',
    '-X',
    'POST',
    req.url,
  }

  for _, h in ipairs(req.headers) do
    table.insert(cmd, '-H')
    table.insert(cmd, h)
  end

  table.insert(cmd, '-d')
  table.insert(cmd, payload)

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then
        return
      end
      local ok, decoded = pcall(vim.fn.json_decode, table.concat(data))
      if ok then
        on_result(provider.parse_response(decoded))
      end
    end,
  })
end

----------------------------------------------------------------------
-- Virtual text completion
----------------------------------------------------------------------

local function clear_completion()
  if context.extmark then
    vim.api.nvim_buf_del_extmark(0, context.ns, context.extmark)
  end
  context.extmark = nil
  context.suggestion = nil
end

local function show_completion(text)
  clear_completion()

  text = vim.trim(text)
  if text == '' then
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  context.suggestion = text
  context.extmark = vim.api.nvim_buf_set_extmark(0, context.ns, row, col, {
    virt_text = { { text, 'Comment' } },
    virt_text_pos = 'overlay',
  })
end

local function accept_completion()
  if not context.suggestion then
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  vim.api.nvim_buf_set_text(0, row, col, row, col, vim.split(context.suggestion, '\n'))

  clear_completion()
end

----------------------------------------------------------------------
-- Public actions
----------------------------------------------------------------------

function M.complete()
  local ctx = context_for_completion()

  local messages = {
    {
      role = 'system',
      content = 'You are a code completion engine. ' .. 'Continue the code at the cursor position. ' .. 'Do not repeat input.',
    },
    {
      role = 'user',
      content = ctx,
    },
  }

  dispatch(messages, show_completion)
end

function M.prompt(opts)
  local instruction = opts.args ~= '' and opts.args or 'Analyze the following code.'

  local messages = {
    { role = 'system', content = instruction },
    { role = 'user', content = buffer_text() },
  }

  dispatch(messages, function(text)
    vim.cmd 'new'
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(vim.trim(text), '\n'))
  end)
end

----------------------------------------------------------------------
-- Setup hooks (called from init.lua)
----------------------------------------------------------------------

function M.setup_commands()
  vim.api.nvim_create_user_command('AIComplete', M.complete, {})

  vim.api.nvim_create_user_command('AIPrompt', M.prompt, { nargs = '*' })

  vim.keymap.set('i', '<C-l>', accept_completion, { desc = 'Accept AI completion' })
end

return M
