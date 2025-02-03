return {
	"julienvincent/nvim-paredit",
	config = function()
		local paredit = require("nvim-paredit")
		paredit.setup({
			-- Change some keys
			keys = {
				["<leader>o"] = false,
				["<leader>r"] = { paredit.api.raise_form, "Raise form" },
			},
		})
	end
}
