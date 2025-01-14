local function is_not_clj_file(filetype)
	return filetype ~= "clojure" and filetype ~= "clojurescript"
end

local function start_clojure_repl()
	local filetype = vim.bo.filetype
	if is_not_clj_file(filetype) then
		print("This command can only be run in Clojure or ClojureScript files.")
		return
	end

	local file_path = vim.fn.expand("%:p")
	if file_path == "" then
		print("Could not identify current file's path")
		return
	end

	local namespace = nil
	for line in io.lines(file_path) do
		namespace = line:match("%(ns%s+([%w%.%-_]+)")
		if namespace then break end
	end

	vim.cmd("split | terminal")


	if namespace then
		local commands = string.format(
			"clojure\n(ns %s)\n(load-file \"%s\")\n",
			namespace,
			file_path
		)
		vim.fn.chansend(vim.b.terminal_job_id, commands)
	else
		vim.fn.chansend(vim.b.terminal_job_id, string.format("clojure\n(load-file \"%s\")\n", file_path))
	end
end

vim.keymap.set("n", "<leader>R", start_clojure_repl, { noremap = true, silent = true })
