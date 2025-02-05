return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gst", vim.cmd.Git)

		local fugitive_augroup = vim.api.nvim_create_augroup("fugitive_augroup", {})

		vim.api.nvim_create_autocmd("BufWinEnter", {
			group = fugitive_augroup,
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end

				-- NOTE: Commands to Git
				local bufr = vim.api.nvim_get_current_buf()
				local remap_opts = { buffer = bufr, remap = false }
				vim.keymap.set("n", "<leader>ggpush", function()
					vim.cmd.Git('push')
				end, remap_opts)
				vim.keymap.set("n", "<leader>ggpull", function()
					vim.cmd.Git('pull', '--rebase')
				end, remap_opts)
				vim.keymap.set("n", "<leader>ga", function()
					vim.cmd.Git('add')
				end, remap_opts)
			end
		})
	end
}
