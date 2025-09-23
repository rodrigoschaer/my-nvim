return { -- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		{ "j-hui/fidget.nvim", opts = {} },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- INFO: Separate configuration for servers
		local servers = {
			clangd = {},
			gopls = {},
			pyright = {},
			kotlin_language_server = {},
			clojure_lsp = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = { disable = { "missing-fields" } },
					},
				},
			},
		}
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = capabilities

					vim.lsp.config(server_name, server)
				end,
			},
		})

		-- INFO: adds config for root path in clojure lsp
		local function custom_clojure_root_dir(pattern)
			local util = require("lspconfig.util")
			local fallback = vim.loop.cwd()
			local patterns = { "project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", ".git", "bb.edn" }
			local root = util.root_pattern(patterns)(pattern)
			return (root or fallback)
		end
		vim.lsp.config.clojure_lsp = {
			root_dir = custom_clojure_root_dir
		}

		-- INFO: install some packages by default
		local ensure_installed = vim.tbl_keys(servers or {})
		local ensure_installed_dap = {
			"debugpy",
			"codelldb",
			"cpptools",
			"delve",
			"js-debug-adapter",
			"kotlin-debug-adapter",
		}
		local ensure_installed_linters = {
			"ktlint",
			"eslint_d",
			"flake8",
		}
		local ensure_installed_formatters = {
			"prettier",
			"black",
			"autoflake",
			"ktlint",
			"goimports",
		}
		vim.list_extend(ensure_installed, ensure_installed_dap)
		vim.list_extend(ensure_installed, ensure_installed_linters)
		vim.list_extend(ensure_installed, ensure_installed_formatters)
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- INFO: Ensure custom keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func,
						{ buffer = event.buf, desc = "LSP: " .. desc, noremap = true })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols,
					"[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols,
					"[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", vim.lsp.buf.hover, "Hover Documentation")

				-- INFO: The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})
	end,
}
