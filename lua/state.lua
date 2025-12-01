local M = {}

-- CORE plugins : ON always
M.enable_core = {}

-- EXTRA plugins: ON by default
M.enable_extra = {
  oil = true,
  minuet = true,
}

-- TESTING plugins: OFF by default
M.enable_testing = {}

return M
