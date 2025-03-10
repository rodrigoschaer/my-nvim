-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlight" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Set newrw open window with space PV
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Moves block of code easily
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

-- Jumps to middle of the file
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Searched term stays in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Pastes over highlighted, maintaining the previously yanked value there
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Takes to register the copy/paste system, so lines can be pasted outside vim
-- This is useful in case the copyboard is not mapped to system by default
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Replaces the piece of text globally in the file
-- Similar to VSCode Control D through all incidences and typing new term
vim.keymap.set("n", "<leader>d", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Replace incidence of searched word
-- After a word is searched and it is desired to change the current incidence
-- Similar to VSCode Control D
vim.keymap.set("n", "<leader>c", "cgn")

-- Print out file extension automatically
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Source current file using lua compiler
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

-- if err = nil
vim.keymap.set(
	"n",
	"<leader>ee",
	"oif err != nil {<CR>}<Esc>Oreturn err<Esc>",
	{ desc = "Insert err not null checking in go" }
)

-- Navigate to previous/next file
vim.keymap.set("n", "<leader><left>", ":bprevious<CR>",
	{ noremap = true, silent = true, desc = "Navigate to previous file on history" })
vim.keymap.set("n", "<leader><right>", ":bnext<CR>",
	{ noremap = true, silent = true, desc = "Navigate to next file on history" })
