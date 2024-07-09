local async = require("plenary.async.tests")
local eq = assert.are.same

describe("WrapVisualSelection", function()
    before_each(function()
        vim.cmd("new")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "test" })
        vim.cmd("normal! ggVG")
    end)

    after_each(function()
        vim.cmd("bwipeout!")
    end)

    async.it("wraps the highlighted text with parenthesis", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>w", true, false, true), "x", false)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("(", true, false, true), "x", false)

        -- Allow some time for the keys to be processed
        vim.wait(100, function()
            return false
        end, 1, false)

        local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        print("Test result: " .. result[1]) -- Add this line for debugging
        eq({ "(test)" }, result)
    end)
end)
