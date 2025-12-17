local json = vim.json

local M = {}

local BASE = 'https://codestral.mistral.ai/v1'

local function api_key()
  return os.getenv 'CODESTRAL_API_KEY'
end

function M.request(endpoint, payload)
  local key = api_key()
  if not key or key == '' then
    return nil, 'CODESTRAL_API_KEY not set'
  end

  local cmd = {
    'curl',
    '-s',
    '-X',
    'POST',
    BASE .. endpoint,
    '-H',
    'Content-Type: application/json',
    '-H',
    'Authorization: Bearer ' .. key,
    '-d',
    json.encode(payload),
  }

  local stdout = {}
  local stderr = {}
  local exit

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      stdout = data
    end,
    on_stderr = function(_, data)
      stderr = data
    end,
    on_exit = function(_, code)
      exit = code
    end,
  })

  vim.wait(10000, function()
    return exit ~= nil
  end)

  if exit ~= 0 then
    return nil, table.concat(stderr, '\n')
  end

  local decoded = vim.json.decode(table.concat(stdout))
  return decoded
end

return M
