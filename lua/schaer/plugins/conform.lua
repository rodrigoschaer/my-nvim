return { -- Autoformat
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
		formatters_by_ft = {
			lua = { "stylua" },
			kotlin = { "ktlint" },
			go = { "gofumpt", "goimports", "golines", "gomodifytags" },
			python = { "isort", "black" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			clojure = { "cljfmt" }
		},
	},
}
