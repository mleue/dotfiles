-- Basic keymaps that don't depend on plugins
local keymap = vim.keymap.set

-- Format with Black (same as your current setup)
keymap('n', '<F3>', ':!black %<CR>', { noremap = true, silent = true })

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", { silent = true })
keymap("n", "<S-h>", ":bprevious<CR>", { silent = true })

-- Telescope keymaps (will be set up when telescope loads)
-- These are defined in the telescope plugin config to avoid errors
