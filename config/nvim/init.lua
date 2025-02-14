-- main settings file
-- per-plugin settings are set up in the plugin files

function Create_settings()
    -- variables to ease config
    local tab_width = 4
    local line_length = 120

    -- tab settings
    vim.opt.tabstop = tab_width
    vim.opt.shiftwidth = tab_width
    vim.opt.expandtab = true

    -- line number settings
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.colorcolumn = tostring(line_length)
    vim.opt.textwidth = line_length
    vim.opt.cursorline = true

    -- list settings (show special chars)
    vim.opt.list = true
    vim.opt.listchars = { tab = "↦ ", trail = "•" }

    -- wildcard completion settings
    vim.opt.wildmode = {"longest", "list", "full"}
    vim.opt.wildignore = {"*.pyc"}

    -- misc. settings
    vim.opt.scrolloff = 3
    vim.opt.termguicolors = true
    vim.opt.smartcase = true

    -- python seems super duper slow, but this helps
    vim.g.loaded_python3_provider = 0
    -- mapleader is so important to me
    vim.g.mapleader = ","
end

function Create_mappings()
    -- tab commands switch buffers (:bn is not that accessible)
    vim.keymap.set("n", "gt", "<cmd>BufferNext<cr>")
    vim.keymap.set("n", "gT", "<cmd>BufferPrevious<cr>")
    vim.keymap.set("n", "<leader>t", "<C-^>")
    vim.keymap.set("n", "<leader>q", "<cmd>BufferPick<cr>")

    -- diagnostic mappings
    vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float)
    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist)

    -- omnifunc more easily accessible
    vim.keymap.set("i", "<C-j>", "<C-X><C-O>")
    -- jump back
    vim.keymap.set("n", "<leader>b", "<C-O>")
    -- remove search highlight
    vim.keymap.set("n", "<leader>/", vim.cmd.nohlsearch)
    -- insert date highlight
    vim.keymap.set("i", "<leader>d", "<C-r>=strftime('%F')<CR>")
end

Create_settings()
Create_mappings()
require("config.lazy")
vim.cmd.colorscheme("catppuccin-mocha")
