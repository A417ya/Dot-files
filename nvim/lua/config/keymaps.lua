--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: config/keymaps.lua
-- Description: Key mapping configs
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>

-- Close all windows and exit from Neovim with <leader> and q

-- vim.keymap.set("n", "<leader>q", ":qa!<CR>", {})
-- fast normal mode
vim.keymap.set("i", "jk", "<Esc>", {})

-- Fast saving with <leader> and s
vim.keymap.set("n", "<leader>s", ":w<CR>", {})

-- Move around splits
vim.keymap.set("n", "<C-h>", "<C-w>h", {})
vim.keymap.set("n", "<C-j>", "<C-w>j", {})
vim.keymap.set("n", "<C-k>", "<C-w>k", {})
vim.keymap.set("n", "<C-l>", "<C-w>l", {})

-- Move code arround
vim.keymap.set("n", "<M-k>", ":m .+1<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<M-j>", ":m .-2<CR>", { silent = true, noremap = true })

-- buffer setup
local opts = { silent = true }
vim.keymap.set("n", "bp", vim.cmd.bprevious, {})
vim.keymap.set("n", "bn", vim.cmd.bnext, {})
vim.keymap.set("n", "bo", vim.cmd.bd, {})

-- Reload configuration without restart nvim
vim.keymap.set("n", "<leader>r", ":so %<CR>", opts)

-- Open Help popup
vim.keymap.set("n", "<leader>h", ":h ")

-- Telescope
-- <leader> is a space now

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {})

local extension = require("telescope").extensions
vim.keymap.set("n", "<leader>fl", extension.lazygit.lazygit, {})

local custom = require("lib.telescope")
vim.keymap.set("n", "<leader>ft", custom.neoconf, {})

-- NvimTree
vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", opts)    -- open/close
vim.keymap.set("n", "<leader>nr", ":NvimTreeRefresh<CR>", opts)  -- refresh
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<CR>", opts) -- search file

-- Terminal
local term = require("neoterm")
vim.keymap.set({ "n", "t" }, "<leader>tt", term.toggle, opts)
-- vim.keymap.set("n", "<leader>tx", ":NeotermExit<CR>", {})

-- oil.nvim setup() config
local oil = require("oil")
vim.keymap.set("n", "-", oil.open_float)

-- aerial setup
vim.keymap.set("n", "<leader>v", ":AerialToggle", { silent = true, noremap = true })
