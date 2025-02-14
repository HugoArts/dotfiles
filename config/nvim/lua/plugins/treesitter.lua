--
-- treesitter is for syntax highlighting and such
--

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufRead",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = {"python", "typescript", "lua", "bash"},
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    }
}
