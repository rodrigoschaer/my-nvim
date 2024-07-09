local M = {}

function M.wrap_visual_selection()
    local wrap_with = vim.fn.input("Wrap with: ")

    local open_char, close_char
    if wrap_with == "<" then
        open_char, close_char = "<", ">"
    elseif wrap_with == "(" then
        open_char, close_char = "(", ")"
    elseif wrap_with == "[" then
        open_char, close_char = "[", "]"
    elseif wrap_with == "{" then
        open_char, close_char = "{", "}"
    else
        open_char, close_char = wrap_with, wrap_with
    end

    local save_reg = vim.fn.getreg('"')
    local save_regtype = vim.fn.getregtype('"')
    local mode = vim.fn.mode()

    vim.cmd('normal! gv"zy')

    local text = vim.fn.getreg("z")
    local wrapped_text = open_char .. text .. close_char
    vim.fn.setreg("z", wrapped_text)
    vim.cmd('normal! gv"zp')

    vim.fn.setreg('"', save_reg, save_regtype)
    if mode == "V" or mode == "v" then
        vim.cmd("normal! gv")
    end

    print("Wrapped text: " .. wrapped_text) -- Add this line for debugging

    return wrapped_text
end

vim.api.nvim_set_keymap(
    "v",
    "<leader>w",
    ':lua require("schaer.custom.wrap_text").wrap_visual_selection()<CR>',
    { noremap = true, silent = true, desc = "[W]rap selected test" }
)

return M
