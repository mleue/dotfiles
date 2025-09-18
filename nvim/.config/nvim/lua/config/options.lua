-- Set leader key (must be before lazy.nvim)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt

-- Essential settings (same as your current config)
opt.autowrite = true                                      -- Enable auto write
opt.clipboard = "unnamedplus"                             -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"                 -- Better completion experience
opt.conceallevel = 3                                      -- Hide * markup for bold and italic
opt.confirm = true                                         -- Confirm to save changes before exiting modified buffer
opt.cursorline = true                                     -- Enable highlighting of the current line
opt.expandtab = true                                      -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt"                            -- tcqj
opt.grepformat = "%f:%l:%c:%m"                            -- Format for grep results
opt.grepprg = "rg --vimgrep"                              -- Use ripgrep for grepping
opt.ignorecase = true                                     -- Ignore case
opt.inccommand = "nosplit"                                -- Preview incremental substitute
opt.laststatus = 0                                        -- Global statusline
opt.list = true                                           -- Show some invisible characters (tabs...)
opt.mouse = "a"                                           -- Enable mouse mode
opt.number = true                                         -- Print line number
opt.pumblend = 10                                         -- Popup blend
opt.pumheight = 10                                        -- Maximum number of entries in a popup
opt.relativenumber = true                                 -- Relative line numbers
opt.scrolloff = 4                                         -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }  -- Session options
opt.shiftround = true                                     -- Round indent
opt.shiftwidth = 2                                        -- Size of an indent
opt.shortmess:append { W = true, I = true, c = true }     -- Avoid hit-enter prompts
opt.sidescrolloff = 8                                     -- Columns of context
opt.signcolumn = "yes"                                    -- Always show the signcolumn
opt.smartcase = true                                      -- Don't ignore case with capitals
opt.smartindent = true                                    -- Insert indents automatically
opt.spelllang = { "en" }                                  -- Spell checking language
opt.splitbelow = true                                     -- Put new windows below current
opt.splitright = true                                     -- Put new windows right of current
opt.tabstop = 2                                           -- Number of spaces tabs count for
opt.termguicolors = true                                  -- True color support
opt.timeoutlen = 300                                      -- Time to wait for a mapped sequence to complete
opt.undofile = true                                       -- Save undo history
opt.undolevels = 10000                                    -- Maximum undo levels
opt.updatetime = 200                                      -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full"                        -- Command-line completion mode
opt.winminwidth = 5                                       -- Minimum window width
opt.wrap = false                                          -- Disable line wrap
opt.cmdheight = 0                                         -- Hide command line unless needed

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
