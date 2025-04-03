vim.opt.number = true              -- Enable line numbers
vim.opt.relativenumber = false     -- Use absolute line numbers
vim.opt.numberwidth = 4            -- Ensures a wide enough column for line numbers

-- Custom status column to add fixed padding and a separator
--vim.opt.statuscolumn = "   %4{v:lnum}      "
--vim.opt.fillchars = { vert = "│" } -- Ensures the separator extends across the full screen

-- Enable mouse support
vim.opt.mouse = "a"

-- Set tab width to 6 spaces
vim.opt.tabstop = 6
vim.opt.shiftwidth = 6
vim.opt.expandtab = true  -- Convert tabs to spaces

-- Enable syntax highlighting (default in Neovim)
vim.cmd("syntax on")

-- Enable auto-indentation
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Enable file type detection and plugin support
vim.cmd("filetype plugin indent on")


-- Auto-install Packer if not installed
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path
    })
    vim.cmd("packadd packer.nvim")
end

-- Load Packer
vim.cmd([[packadd packer.nvim]])

-- Plugins go inside this function
require("packer").startup(function(use)
    use "wbthomason/packer.nvim"  -- Packer can manage itself
    use "nvim-tree/nvim-tree.lua"  -- File explorer
    use "kyazdani42/nvim-web-devicons" -- Icons for file types
    use "vim-airline/vim-airline" -- Status bar
    use "neovim/nvim-lspconfig"       -- LSP support
    use "nvim-treesitter/nvim-treesitter" -- Better syntax highlighting
    use "onsails/lspkind.nvim" -- Icons for completion
    use "hrsh7th/nvim-cmp"            -- Autocompletion
    use "hrsh7th/cmp-nvim-lsp"        -- LSP-based completion
    use "hrsh7th/cmp-buffer"          -- Buffer completion
    use "windwp/nvim-autopairs"       -- Auto-close brackets & quotes
end)

-- Configure nvim-tree (File Explorer)
require("nvim-tree").setup()

-- Keybinding to toggle file explorer
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Setup LSP for C/C++
local lspconfig = require("lspconfig")
lspconfig.clangd.setup({}) -- Uses system-installed clangd

-- Setup Autocompletion (nvim-cmp)
local cmp = require("cmp")

-- for the icons in the suggestion box
local lspkind = require("lspkind")

-- cmp.setup({
--    mapping = {
--        ["<C-Space>"] = cmp.mapping.complete(),  -- Trigger completion
--        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
--    },
--    sources = {
--        { name = "nvim_lsp" }, -- Use LSP for suggestions
--        { name = "buffer" },   -- Complete words from buffer
--    }
-- })

cmp.setup({
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),  -- Trigger completion
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
    },

    sources = {
        { name = "nvim_lsp" }, -- Use LSP for suggestions
        { name = "buffer" },   -- Complete words from buffer
    },

    -- ✨ UI Improvements ✨
    formatting = {
        format = function(entry, vim_item)
            -- Add icons to suggestion items
            local kind_icons = {
                Text = "", Method = "", Function = "󰊕", Constructor = "",
                Field = "", Variable = "", Class = "", Interface = "",
                Module = "", Property = "", Unit = "", Value = "",
                Enum = "", Keyword = "", Snippet = "", Color = "",
                File = "", Reference = "", Folder = "", EnumMember = "",
                Constant = "", Struct = "", Event = "", Operator = "",
                TypeParameter = "",
            }
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)

	    -- Use lspkind to ensure correct formatting and fallback icons
            vim_item = lspkind.cmp_format({
                mode = "symbol_text", -- Show both icon and text
                maxwidth = 50, -- Prevent long text from overflowing
                ellipsis_char = "...", -- Show "..." for truncated text
            })(entry, vim_item)

            return vim_item
        end,
    },

    -- ✨ Make the menu bordered ✨
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    -- ✨ Improve the selection experience ✨
    experimental = {
        ghost_text = true, -- Faint preview of text
    },
})


-- Enable Treesitter for C/C++
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp" },
    highlight = { enable = true }
})

-- Enable Auto-closing brackets & quotes
require("nvim-autopairs").setup({})

-- Change colors of the autocomplete menu for a dark background
vim.cmd([[
    highlight! CmpItemAbbr guifg=#C5C8C6
    highlight! CmpItemAbbrMatch guifg=#FFD700 gui=bold
    highlight! CmpItemAbbrMatchFuzzy guifg=#FFA500 gui=bold
    highlight! CmpItemKind guifg=#56B6C2
    highlight! CmpItemMenu guifg=#999999
]])


