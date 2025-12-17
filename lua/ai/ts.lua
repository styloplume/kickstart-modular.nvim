local M = {}

local ts = vim.treesitter

-- Nodes that usually represent "units of meaning"
local PREFERRED_NODES = {
  function_definition = true,
  function_declaration = true,
  method_definition = true,
  class_definition = true,
}

-- Fallback nodes
local FALLBACK_NODES = {
  block = true,
}

local function get_node_at_cursor()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local parser = ts.get_parser(0)
  if not parser then
    return nil
  end

  local tree = parser:parse()[1]
  return tree:root():named_descendant_for_range(row, col, row, col)
end

local function climb(node)
  while node do
    if PREFERRED_NODES[node:type()] then
      return node
    end
    node = node:parent()
  end
end

local function fallback(node)
  while node do
    if FALLBACK_NODES[node:type()] then
      return node
    end
    node = node:parent()
  end
end

function M.extract()
  local node = get_node_at_cursor()
  if not node then
    return nil
  end

  return climb(node) or fallback(node) or node
end

function M.node_text(node)
  return vim.treesitter.get_node_text(node, 0)
end

function M.node_text_upto_cursor(node)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local sr, sc, er, ec = node:range()
  if row < sr or row > er then
    return M.node_text(node)
  end

  local lines = vim.api.nvim_buf_get_lines(0, sr, row + 1, false)
  lines[#lines] = string.sub(lines[#lines], 1, col)

  return table.concat(lines, "\n")
end

return M
