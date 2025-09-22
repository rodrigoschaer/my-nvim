return {
	"editor-code-assistant/eca-nvim",
	dependencies = {
		"MunifTanjim/nui.nvim", -- Required: UI framework
		"nvim-lua/plenary.nvim", -- Optional: Enhanced async operations
	},
	keys = {
		{ "<leader>ec", "<cmd>EcaChat<cr>",   desc = "Open ECA chat" },
		{ "<leader>ef", "<cmd>EcaFocus<cr>",  desc = "Focus ECA sidebar" },
		{ "<leader>et", "<cmd>EcaToggle<cr>", desc = "Toggle ECA sidebar" },
	},
	opts = {
		debug = false,
		server_path = "",
		behaviour = {
			auto_set_keymaps = true,
			auto_focus_sidebar = true,
		},
	}
}
