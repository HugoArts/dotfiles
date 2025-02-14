--
-- basically all related to lsp will go in here
--

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>ad", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "<leader>ag", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "<leader>at", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>ah", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<leader>aH", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>ai", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<leader>ar", ":IncRename ", bufopts)
    vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "<leader>ae", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<leader>af", function() vim.lsp.buf.format { async = true } end, bufopts)
end

return {
    { "williamboman/mason.nvim", name = "mason", config = true },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason",
            { "williamboman/mason-lspconfig.nvim", config = true },
            { "smjonas/inc-rename.nvim" },
        },
        config = function()
            local lspconf = require("lspconfig")

            lspconf.pylsp.setup {
                on_attach = on_attach,
                cmd = { "pylsp", "-v" },
                settings = { pylsp = {
                    configurationSources = { "flake8" },
                    plugins = {
                        mypy = { enabled = true },
                        ruff = {
                            enabled = true,
                            lineLength = 120,
                            extendSelect = { "I" },
                            format = { "I" },
                        },

                        flake8 = { enabled = false },
                        autopep8 = { enabled = false },
                        yapf = { enabled = false },
                        black = { enabled = false },
                    },
                } }
            }

            lspconf.lua_ls.setup {
                on_attach = on_attach,
                settings = {
                    Lua = { diagnostics = { globals = { "vim" } } }
                }
            }

            lspconf.rust_analyzer.setup { on_attach = on_attach, }
            lspconf.ts_ls.setup { on_attach = on_attach, }
            lspconf.eslint.setup { on_attach = on_attach, }
            lspconf.cssls.setup { on_attach = on_attach, }
        end,
    }
}
