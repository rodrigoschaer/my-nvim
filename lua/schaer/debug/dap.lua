-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mxsdev/nvim-dap-vscode-js",
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		{
			"microsoft/vscode-js-debug",
			opt = true,
			run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		},
	},
	config = function()
		-- DAP
		local dap, dapui = require("dap"), require("dapui")

		-- Set keymaps to control the debugger
		vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "Debug: Continue" })
		vim.keymap.set("n", "<F10>", require("dap").step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F11>", require("dap").step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F12>", require("dap").step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint, { desc = "Debug: Toggle [B]reakpoint" })
		vim.keymap.set("n", "<space>gb", dap.run_to_cursor, { desc = "Debug: run to cursor" })
		vim.keymap.set("n", "<leader>B", function()
			require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: set [B]reakpoint" })

		-- Eval var under cursor
		vim.keymap.set("n", "<space>?", function()
			require("dapui").eval(nil, { enter = true })
		end)

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({})
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close({})
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close({})
		end

		require("dap-vscode-js").setup({
			-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
			-- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
			adapters = { "chrome", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
			-- log_file_path = vim.fn.stdpath('data') .. "/lazy/vscode-js-debug/" .. "src/dap_vscode_js.log" -- Path for file logging
			-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
			-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
		})

		-- DAP UI
		dapui.setup()

		vim.keymap.set("n", "<leader>ui", dapui.toggle)
	end,
}
