-- Basic settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.tabstop = 4          -- Number of spaces tabs count for
vim.opt.shiftwidth = 4       -- Size of indent
vim.opt.smartindent = true   -- Auto indent new lines
vim.opt.wrap = false          -- Don't wrap long lines
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard
vim.opt.mouse = "a"               -- Enable mouse support
vim.opt.termguicolors = true
vim.opt.showmode = false

-- Better editing experience
vim.opt.cursorline = true    -- Highlight current line
vim.opt.signcolumn = "yes"   -- Always show sign column
vim.opt.scrolloff = 8        -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8    -- Keep 8 columns left/right of cursor

-- Search settings
vim.opt.ignorecase = true    -- Ignore case in search
vim.opt.smartcase = true     -- Unless uppercase is used
vim.opt.hlsearch = true      -- Highlight search results
vim.opt.incsearch = true     -- Incremental search

-- Split settings
vim.opt.splitright = true    -- Vertical splits go right
vim.opt.splitbelow = true    -- Horizontal splits go below

-- Completion settings
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10       -- Max items in completion menu

-- File settings
vim.opt.backup = false       -- Don't create backup files
vim.opt.swapfile = false     -- Don't create swap files
vim.opt.undofile = true      -- Enable persistent undo
vim.opt.updatetime = 250     -- Faster completion and diagnostics

-- Fold settings
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false   -- Don't fold by default
