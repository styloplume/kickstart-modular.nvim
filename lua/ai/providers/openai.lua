local M = {}

M.name = "openai"
M.default_model = "gpt-4.1-mini"
M.api_key_env = "OPENAI_API_KEY"
M.url = "https://api.openai.com/v1/chat/completions"

function M.build_request(opts)
  return {
    url = M.url,
    headers = {
      "Content-Type: application/json",
      "Authorization: Bearer " .. opts.api_key,
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
  local msg = resp.choices[1].message
  return type(msg.content) == "table" and msg.content[1].text or msg.content
end

return M
