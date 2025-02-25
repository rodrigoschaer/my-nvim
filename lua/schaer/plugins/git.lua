return {
	{ -- Main GIT plugin to manage files
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "gs", vim.cmd.Git)

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
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"f-person/git-blame.nvim",
		-- load the plugin at startup
		event = "VeryLazy",
		-- Because of the keys part, you will be lazy loading this plugin.
		-- The plugin wil only load once one of the keys is used.
		-- If you want to load the plugin at startup, add something like event = "VeryLazy",
		-- or lazy = false. One of both options will work.
		opts = {
			-- your configuration comes here
			-- for example
			enabled = true, -- if you want to enable the plugin
			message_template = "<author> • <summary> • <date> • <<sha>>", -- template for the blame message, check the Message template section for more options
			date_format = "%d-%m-%Y %H:%M:%S", -- template for the date, check Date format section for more options
			virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
		},
	},
}
