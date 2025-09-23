return {
	{ -- Colorize logs in Conjure
		"m00qek/baleia.nvim",
		version = "*",
		config = function()
			vim.g.conjure_baleia = require("baleia").setup({ line_starts_at = 3 })

			local augroup = vim.api.nvim_create_augroup("ConjureBaleia", { clear = true })

			vim.api.nvim_create_user_command("BaleiaColorize", function()
				vim.g.conjure_baleia.once(vim.api.nvim_get_current_buf())
			end, { bang = true })

			vim.api.nvim_create_user_command("BaleiaLogs", vim.g.conjure_baleia.logger.show, { bang = true })
		end,
	},
	{ -- Connect with local repl, enable clojure development in nvim
		"Olical/conjure",
		ft = { "clojure", "fennel", "python" },
		config = function()
			require("conjure.main").main()
			require("conjure.mapping")["on-filetype"]()
		end,
		init = function()
			-- print color codes if baleia.nvim is available
			local colorize = true
			vim.g["conjure#log#strip_ansi_escape_sequences_line_limit"] = colorize and 1 or nil

			--    disable diagnostics in log buffer and colorize it
			vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
				pattern = "conjure-log-*",
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					vim.diagnostic.enable(false, { bufnr = buffer })
					if colorize and vim.g.conjure_baleia then
						vim.g.conjure_baleia.automatically(buffer)
					end
				end,
			})

			vim.g["conjure#mapping#prefix"] = ","
			-- Disable the documentation mapping
			vim.g["conjure#mapping#doc_word"] = false
			-- Rebind it from K to <prefix>gk
			vim.g["conjure#mapping#doc_word"] = "gk"
		end,
		keys = {
			-- Add custom mapping for running project tests
			{ ",pt", "<cmd>ConjureEval (run-project-tests)<cr>", desc = "Run project tests" }
		},

		-- Optional cmp-conjure integration
		dependencies = { "PaterJason/cmp-conjure", "clojure-vim/vim-jack-in" },

	},
	{ -- Clojure completion configuration
		"PaterJason/cmp-conjure",
		lazy = true,
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, { name = "conjure" })
			return cmp.setup(config)
		end,
	},
	{ -- REPL ready with vim command line
		"clojure-vim/vim-jack-in",
		dependencies = {
			"tpope/vim-dispatch",
			"radenling/vim-dispatch-neovim"
		},
		config = function()
			vim.keymap.set("n", "<leader>L", "<CMD>Lein<CR>", { desc = "Opens Lein REPL with Jack In" })
		end
	},
	{ -- Clojure snippets
		"L3MON4D3/LuaSnip",
		ft = { "clojure" },
		config = function()
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node

			ls.add_snippets("clojure", {
				s("sdefn", {
					t("(s/defn "), i(1, "function-name"), t({ "", "  []", "  ())" })
				})
			})
		end
	}
}
