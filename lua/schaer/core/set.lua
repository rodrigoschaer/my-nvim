-- Sets the global boolean have_nerd_font to true
vim.g.have_nerd_font = true

--[[ Line numbers configurations ]]

-- Enable line number
vim.opt.number = true

-- Relative line numbers
vim.opt.relativenumber = true

-- Active line colors
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "CursorLineNr", {
	fg = "#FF00B7",
	bold = true,
})
vim.opt.cursorline = true

-- Column limit highlight
-- vim.opt.colorcolumn = "80"

-- [[ vim.opt => Options from Vim ]]

-- Enable mouse mode
vim.opt.mouse = "a"

-- Hide mode from command
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Enable pairing with System and Nvim clipboard
vim.opt.clipboard = "unnamedplus"

-- Save undo history
vim.opt.undofile = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Enable smart indent
vim.opt.smartindent = false

-- Line wrap
vim.opt.wrap = true

-- Sets cursor offset to middle screen
vim.opt.so = 9999
