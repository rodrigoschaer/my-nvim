return { -- Autoformat
	"stevearc/conform.nvim",
	opts = function()
		-- Pick the JS/TS formatter per-project: repos using the oxc toolchain
		-- ship a `.oxfmtrc.json`; everything else falls back to prettier.
		-- (prettier ignores .oxfmtrc.json, so running it on an oxfmt repo
		-- reflows the whole file to prettier's defaults — e.g. 80 vs 150 cols.)
		local function js_formatter(bufnr)
			local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
			local has_oxfmt = vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc" }, {
				upward = true,
				path = dir,
			})[1]
			if has_oxfmt then
				return { "oxfmt" }
			end
			return { "prettier" }
		end

		return {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters = {
				-- oxc formatter. Prefer the project-local binary in
				-- node_modules/.bin, fall back to whatever is on $PATH.
				oxfmt = {
					command = function(_, ctx)
						local nm = vim.fs.find("node_modules", {
							upward = true,
							type = "directory",
							path = ctx.dirname,
						})[1]
						if nm then
							local bin = nm .. "/.bin/oxfmt"
							if vim.uv.fs_stat(bin) then
								return bin
							end
						end
						return "oxfmt"
					end,
					args = { "--stdin-filepath", "$FILENAME" },
					stdin = true,
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				kotlin = { "ktlint" },
				go = { "gofumpt", "goimports", "golines", "gomodifytags" },
				python = { "isort", "black" },
				javascript = js_formatter,
				javascriptreact = js_formatter,
				typescript = js_formatter,
				typescriptreact = js_formatter,
				json = { "prettier" },
				jsonc = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				clojure = { "cljfmt" },
			},
		}
	end,
}
