--
-- simple packages that don't need configuration
--

return {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "nvim-tree/nvim-web-devicons", name = "web-devicons", opts = {} },
    { "kylechui/nvim-surround" },

    {
        "tversteeg/registers.nvim",
        cmd = "Registers",
        name = "registers",
        config = true,
        keys = {
            { "\"",    mode = { "n", "v" } },
            { "<C-R>", mode = "i" }
        },
    }
}
