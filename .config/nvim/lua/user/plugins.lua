-- which-key
vim.o.timeout = true
vim.o.timeoutlen = 300

-- telescope
local telescope = require('telescope.builtin')
-- finding files (by name or content)
vim.keymap.set('n', '<leader>ff', telescope.find_files, {desc = "Find files"})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {desc = "Grep files"})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {desc = "Find buffers"})
-- searching sources
vim.keymap.set('n', '<leader>sc', telescope.command_history, {desc = "Search command history"})
vim.keymap.set('n', '<leader>ss', telescope.search_history, {desc = "Search search history"})
vim.keymap.set('n', '<leader>sC', telescope.commands, {desc = "Search commands"})
vim.keymap.set('n', '<leader>sk', telescope.keymaps, {desc = "Search keymaps"})
vim.keymap.set('n', '<leader>sm', telescope.marks, {desc = "Search marks"})

-- tokyonight
vim.cmd[[colorscheme tokyonight]]

-- treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "python", "rust", "typescript" },
  highlight = {
    enable = true,
  },
}

-- lsp-zero
local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)
lsp.setup()
-- vim.keymap.set('n', 'gd', telescope.lsp_definitions, {desc = "Goto Definitions"})
-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {desc = "Goto Declaration"})
-- vim.keymap.set('n', 'gr', telescope.lsp_references, {desc = "Goto References"})
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, {desc = "Hover"})
-- vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, {desc = "Line diagnostics"})
-- vim.keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', {desc = "Lsp Info"})
-- vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, {desc = "Format document"})
-- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc = "Code action"})
-- Check if the current buffer is a Python file
-- Set the F3 key to execute ':!black %' in normal mode for Python files
  vim.keymap.set('n', '<F3>', ':!black %<CR>', { noremap = true, silent = true })


-- Copilot

-- bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}

-- Etude
vim.keymap.set("n", "<leader>es", ":EtudeStart<cr>", {})
vim.keymap.set("n", "<leader>ea", ":EtudeAbort<cr>", {})
vim.keymap.set("n", "<leader>er", ":EtudeRun<cr>", {})
vim.keymap.set("n", "<leader>et", ":EtudeTest<cr>", {})
vim.keymap.set("n", "<leader>ed", ":EtudeDiff<cr>", {})
vim.keymap.set("n", "<leader>e1", ":EtudeDone 1<cr>", {})
vim.keymap.set("n", "<leader>e2", ":EtudeDone 2<cr>", {})
vim.keymap.set("n", "<leader>e3", ":EtudeDone 3<cr>", {})
vim.keymap.set("n", "<leader>e4", ":EtudeDone 4<cr>", {})
vim.keymap.set("n", "<leader>e5", ":EtudeDone 5<cr>", {})
vim.keymap.set("n", "<leader>ei", ":EtudesInfo<cr>", {})
