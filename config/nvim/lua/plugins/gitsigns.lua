--
-- gitsigns displays git diff info on the left
--

local on_attach = function(bufnr)
    local gs = require("gitsigns")
    local map = function(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        return vim.keymap.set(mode, l, r, opts)
    end

    map({"n", "v"}, "<leader>vs", ":Gitsigns stage_hunk<CR>")
    map({"n", "v"}, "<leader>vr", ":Gitsigns reset_hunk<CR>")

    map("n", "<leader>vS", gs.stage_buffer)
    map("n", "<leader>vR", gs.reset_buffer)

    map("n", "<leader>vu", gs.undo_stage_hunk)
    map("n", "<leader>vp", gs.preview_hunk)

    map("n", "<leader>vb", function() gs.blame_line{full=true} end)
    map("n", "<leader>vB", gs.toggle_current_line_blame)
    map("n", "<leader>vd", gs.diffthis)
    map("n", "<leader>vD", function() gs.diffthis("~") end)
    map("n", "<leader>vx", gs.toggle_deleted)
end

return {
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = { on_attach = on_attach },
        config = true,
    }
}
