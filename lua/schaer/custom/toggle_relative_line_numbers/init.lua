local function toggle_relative_line_numbers()
	local current_value = vim.wo.relativenumber
	vim.wo.relativenumber = not current_value
end

vim.api.nvim_create_user_command('ToggleRelativeLineNumbers', toggle_relative_line_numbers, {
	desc = 'Toggle relative line numbers'
})

vim.api.nvim_set_keymap('n', '<leader>rln', ':ToggleRelativeLineNumbers<CR>', {
	noremap = true,
	silent = true,
	desc = 'Toggle [r]elative [l]ine [n]umbers'
})
