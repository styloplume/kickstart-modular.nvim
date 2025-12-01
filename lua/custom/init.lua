local module = {}

function module.Setup()
  -- Force use of clang to build stuff
  require('nvim-treesitter.install').compilers = { 'clang', 'gcc' }
end

return module
