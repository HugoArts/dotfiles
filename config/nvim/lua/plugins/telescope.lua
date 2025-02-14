--
-- telescope is the fuzzy file finder
--

return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "web-devicons",
            "nvim-lua/plenary.nvim",
            { 'nvim-telescope/telescope-fzf-native.nvim', build = "make" },
        },
        config = function(plugin)
            local telescope = require("telescope")
            telescope.setup({})
            telescope.load_extension("fzf")
        end,
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end },
            { "<leader>fd", function() require("telescope.builtin").diagnostics() end },
            { "<leader>fr", function() require("telescope.builtin").lsp_references() end },
            { "<leader>fi", function() require("telescope.builtin").lsp_incoming_calls() end },
            { "<leader>fo", function() require("telescope.builtin").lst_outgoing_calls() end },
        },
    },
}
