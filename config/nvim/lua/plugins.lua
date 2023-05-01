--
-- package management
--

-- automatically run PackerCompile when this file is updated
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

-- plugins with configuration
return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use "catppuccin/nvim"
    use "nvim-tree/nvim-web-devicons"
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"

    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = { {"nvim-lua/plenary.nvim"} },
        config = function()
            local telescope = require("telescope")
            telescope.setup { on_attach = on_attach }
            telescope.load_extension("fzf")

            local builtin = require("telescope.builtin")
            local opts = { noremap=true, silent=true, buffer=bufnr }

            vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)
            vim.keymap.set("n", "<leader>fd", builtin.diagnostics, opts)
            vim.keymap.set("n", "<leader>fr", builtin.lsp_references, opts)
            vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, opts)
            vim.keymap.set("n", "<leader>fo", builtin.lsp_outgoing_calls, opts)
        end
    }

    use {
        "nvim-lualine/lualine.nvim",
        requires = {"nvim-tree/nvim-web-devicons", opt=true},
        config = function()
            local gitstatus = function()
                local signs = vim.b.gitsigns_status_dict
                if not signs then
                    return nil
                end
                return {added = signs.added, modified = signs.changed, removed = signs.removed}
            end
            require("lualine").setup {
                sections = {
                    lualine_b = {
                        "branch",
                        {"diff", source = gitstatus},
                        "diagnostics",
                    }
                }
            }
        end,
    }

    use {
        "romgrk/barbar.nvim",
        requires = {"nvim-tree/nvim-web-devicons"},
        config = function()
            require("bufferline").setup({
                icons = { filetype = { enabled = true } },
            })
        end,
    }

    use {
        "neovim/nvim-lspconfig",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
            local lspconf = require("lspconfig")

            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = { noremap=true, silent=true, buffer=bufnr }
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

            lspconf.pylsp.setup {
                on_attach = on_attach,
                settings = {pylsp = {
                    configurationSources = {"flake8"},
                    plugins = {
                        pycodestyle = { enabled=false },
                        pyflakes = { enabled=false },
                        flake8 = { enabled=true },
                    },
                }}
            }

            lspconf.tsserver.setup {
                on_attach = on_attach,
            }
            lspconf.eslint.setup {
                on_attach = on_attach,
            }

            lspconf.cssls.setup {
                on_attach = on_attach,
            }
        end
    }

    use({ "yioneko/nvim-yati", tag = "*", requires = "nvim-treesitter/nvim-treesitter" })
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {"python", "typescript", "lua", "bash"},
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = false },
                yati = { enable = true },
            }
        end,
    }

    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            -- adapters
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-jest",
        },
        config = function()
            local neotest = require("neotest")

            neotest.setup({
                adapters = {
                    require("neotest-python"),
                    require("neotest-jest")({
                        jestCommand = "npm test --",
                        env = { CI = true },
                    }),
                },
                output = { open_on_run = false },
                quickfix = { open = false },
            })

            local opts = { noremap=true, silent=true }
            local run_all_file = function() neotest.run.run(vim.fn.expand("%")) end
            vim.keymap.set("n", "<leader>tt", neotest.run.run, opts)
            vim.keymap.set("n", "<leader>tf", run_all_file, opts)
            vim.keymap.set("n", "<leader>tn", function() neotest.jump.next({status="failed"}) end, opts)
            vim.keymap.set("n", "<leader>tp", function() neotest.jump.prev({status="failed"}) end, opts)
            vim.keymap.set("n", "<leader>to", function() neotest.output.open({enter=true}) end, opts)
            vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, opts)
        end,
    }

    use {
        "kylechui/nvim-surround",
        tag = "*",
        config = function()
            require("nvim-surround").setup()
        end,
    }

    use {
        "kosayoda/nvim-lightbulb",
        requires = "antoinemadec/FixCursorHold.nvim",
        config = function()
            require("nvim-lightbulb").setup({
                sign = {priority = 100},
                autocmd = {enabled = true}
            })
        end,
    }

    use {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup()
        end,
    }

    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local map = function(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    opts.silent = true
                    opts.noremap = true
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

            require("gitsigns").setup {
                on_attach = on_attach,
            }
        end,
    }
end)

