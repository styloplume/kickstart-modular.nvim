local M = {}

-- CORE plugins : ON always
M.enable_core = {}

-- EXTRA plugins: ON by default
M.enable_extra = {}

-- TESTING plugins: OFF by default
M.enable_testing = {
  work = true,
  telekasten = true,
  minuet = true, -- TODO : this needs to define plugin availability elsewhere (blink-cmp)
}

return M
