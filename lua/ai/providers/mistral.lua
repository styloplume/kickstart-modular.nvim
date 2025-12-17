local M = {}

M.name = 'mistral'
M.default_model = 'codestral-2501'
M.api_key_env = 'CODESTRAL_API_KEY'
M.url = 'https://api.mistral.ai/v1/chat/completions'

function M.build_request(opts)
  return {
    url = M.url,
    headers = {
      'Content-Type: application/json',
      'Authorization: Bearer ' .. opts.api_key,
    },
    body = {
      model = opts.model or M.default_model,
      messages = opts.messages,
      temperature = opts.temperature,
      max_tokens = opts.max_tokens,
    },
  }
end

function M.parse_response(resp)
  return resp.choices[1].message.content
end

return M
