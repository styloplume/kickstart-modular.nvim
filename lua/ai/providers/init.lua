local M = {}

M.mistral = require 'ai.providers.mistral'
M.openai = require 'ai.providers.openai'
M.codestral = require 'ai.providers.codestral'

function M.get(name)
  return M[name]
end

return M
