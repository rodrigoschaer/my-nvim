return {
	{
		"Olical/conjure",
		ft = { "clojure", "fennel", "python" }, -- etc
		lazy = true,
		init = function()
			-- Set configuration options here
			-- Uncomment this to get verbose logging to help diagnose internal Conjure issues
			-- This is VERY helpful when reporting an issue with the project
			-- vim.g["conjure#debug"] = true

			vim.g["conjure#mapping#prefix"] = ","
		end,

		-- Optional cmp-conjure integration
		dependencies = { "PaterJason/cmp-conjure", "clojure-vim/vim-jack-in" },
	},
	{
		"PaterJason/cmp-conjure",
		lazy = true,
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, { name = "conjure" })
			return cmp.setup(config)
		end,
	},
	{
		"clojure-vim/vim-jack-in",
		dependencies = {
			"tpope/vim-dispatch",
			"radenling/vim-dispatch-neovim"
		},
		config = function()
			vim.keymap.set("n", "<leader>L", "<CMD>Lein<CR>", { desc = "Opens Lein REPL with Jack In" })
		end
	}
}
