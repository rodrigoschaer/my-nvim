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

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- INFO: mason-lspconfig v2 dropped the `handlers` API. The modern path is
		-- Neovim 0.11+'s `vim.lsp.config()` (per-server settings) + automatic
		-- enabling by mason-lspconfig. We register capabilities globally and then
		-- layer per-server settings on top.
		vim.lsp.config("*", { capabilities = capabilities })

		-- Inlay hints / inlay-hint config shared by vtsls (TS & JS).
		local ts_inlay_hints = {
			parameterNames = { enabled = "literals" },
			parameterTypes = { enabled = true },
			variableTypes = { enabled = true },
			propertyDeclarationTypes = { enabled = true },
			functionLikeReturnTypes = { enabled = true },
			enumMemberValues = { enabled = true },
		}

		-- INFO: Separate configuration for servers
		local servers = {
			clangd = {},
			gopls = {},
			pyright = {},
			kotlin_language_server = {},
			clojure_lsp = {
				root_markers = { "project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", "bb.edn", ".git" },
			},
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
			-- TypeScript / JavaScript (vtsls wraps tsserver with extra features)
			vtsls = {
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = { completeFunctionCalls = true },
						inlayHints = ts_inlay_hints,
					},
					javascript = {
						updateImportsOnFileMove = { enabled = "always" },
						inlayHints = ts_inlay_hints,
					},
				},
			},
			-- ESLint: diagnostics + fix-on-save (see LspAttach below)
			eslint = {
				settings = {
					workingDirectories = { mode = "auto" },
				},
			},
		}

		for name, cfg in pairs(servers) do
			vim.lsp.config(name, cfg)
		end

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			-- automatic_enable defaults to true: installed servers above get
			-- enabled with the config we registered via vim.lsp.config().
		})

		-- INFO: install some non-LSP packages by default
		local ensure_installed = {}
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
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func,
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
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("K", vim.lsp.buf.hover, "Hover Documentation")

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- INFO: Enable inlay hints by default where supported, with a toggle.
				if client and client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(
							not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
							{ bufnr = event.buf }
						)
					end, "[T]oggle Inlay [H]ints")
				end

				-- INFO: TypeScript/JavaScript source-action keymaps (vtsls).
				if client and client.name == "vtsls" then
					local function source_action(action)
						return function()
							vim.lsp.buf.code_action({
								context = { only = { action }, diagnostics = {} },
								apply = true,
							})
						end
					end
					map("<leader>oi", source_action("source.organizeImports"), "[O]rganize [I]mports")
					map("<leader>ai", source_action("source.addMissingImports.ts"), "[A]dd Missing [I]mports")
					map("<leader>ru", source_action("source.removeUnused.ts"), "[R]emove [U]nused")
					map("<leader>fa", source_action("source.fixAll.ts"), "[F]ix [A]ll")
				end

				-- INFO: ESLint fix-on-save.
				if client and client.name == "eslint" then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = event.buf,
						command = "LspEslintFixAll",
					})
				end

				-- INFO: The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
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
