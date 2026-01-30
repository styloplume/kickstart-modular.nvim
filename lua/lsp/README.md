So the whole idea here was to share defaults between all LSP's,
through utils/lsp.lua (blink capabilities + keymaps)

But it turns out what I'm doing here is overwriting nvim-lspconfig defaults,
losing all the cool stuff like clangd's switch source/header command.

Not doing any config stuff here restores them, which means I should move my custom
stuff to after/lsp/<server>.lua if I want to change anything.

That doesn't take away the possibility to share things between all LSP's of course.

