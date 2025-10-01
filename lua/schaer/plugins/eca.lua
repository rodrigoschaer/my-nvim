return {
	"editor-code-assistant/eca-nvim",
	dependencies = {
		"MunifTanjim/nui.nvim", -- Required: UI framework
		"nvim-lua/plenary.nvim", -- Optional: Enhanced async operations
	},
	keys = {
		{ "<leader>eco", "<cmd>EcaChat<cr>",         desc = "[EC]A: [O]pen ECA chat" },
		{ "<leader>ecf", "<cmd>EcaFocus<cr>",        desc = "[EC]A: [F]ocus ECA sidebar" },
		{ "<leader>ect", "<cmd>EcaToggle<cr>",       desc = "[EC]A: [T]oggle ECA sidebar" },
		{ "<leader>ecs", "<cmd>EcaAddSelection<cr>", desc = "[EC]A: Adds [S]election" },
	},
	main = "eca",
	opts = {}
}
