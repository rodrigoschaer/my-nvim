return {
	"scalameta/nvim-metals",
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"hrsh7th/nvim-cmp", -- Required for autocompletion
		"mfussenegger/nvim-dap", -- Optional, for debugging
	},
	ft = { "scala", "sbt", "sc" },
	opts = {
		-- custom options
	},
	config = function(_, opts)
		require("metals").setup(opts)
	end,
}
