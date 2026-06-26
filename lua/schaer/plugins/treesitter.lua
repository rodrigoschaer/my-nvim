return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter` (main branch)
		--
		-- The `main` branch is a rewrite: there is no `ensure_installed`,
		-- `auto_install`, or `configs.setup`. Instead we install the parsers we
		-- want and enable highlighting/indentation per-buffer via a FileType
		-- autocommand.

		local parsers = {
			"bash",
			"c",
			"html",
			"lua",
			"markdown",
			"markdown_inline", -- required alongside `markdown` for proper highlighting
			"vim",
			"vimdoc",
			"go",
			"kotlin",
			"javascript",
			"typescript",
			"tsx", -- required for React .tsx (typescriptreact)
			"json",
			"python",
			"clojure",
		}

		-- Install any parsers from the list that aren't present yet.
		require("nvim-treesitter").install(parsers)

		-- Enable Tree-sitter highlighting + indentation for any buffer whose
		-- filetype maps to an installed parser.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("schaer_treesitter", { clear = true }),
			callback = function(args)
				local buf = args.buf
				local ft = vim.bo[buf].filetype
				local lang = vim.treesitter.language.get_lang(ft)
				if not lang then
					return
				end

				-- Only proceed if a parser for this language is actually available.
				-- `language.add` returns `nil, err` (no exception) on failure, so we
				-- must check the *return value*, not just that pcall didn't throw.
				local ok, added = pcall(vim.treesitter.language.add, lang)
				if not ok or not added then
					return
				end

				vim.treesitter.start(buf, lang)
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
