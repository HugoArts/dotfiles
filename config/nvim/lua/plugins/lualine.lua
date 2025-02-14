--
-- lualine is a statusline
--
local gitstatus = function()
    local signs = vim.b.gitsigns_status_dict
    if not signs then return nil end
    return { added = signs.added, modified = signs.changed, removed = signs.removed }
end

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "web-devicons" },
        opts = {
            sections = { lualine_b = { "branch", { "diff", source = gitstatus }, "diagnostics" } },
        },
    }
}
