require("schaer.core.remap")
require("schaer.core.set")
require("schaer.core.autocommands")
require("schaer.core.terminal")
require("schaer.custom.init")
require("schaer.lazy")

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25


-- Active line colors
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "CursorLineNr", {
	fg = "#FF00B7",
	bold = true,
})
vim.opt.cursorline = true
