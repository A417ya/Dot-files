local M = {}
local builtin = require("telescope.builtin")

local theme = require("telescope.themes")

M.neoconf = function()
  builtin.find_files({
    cwd = "~/.config/nvim",
    file_encoding = "utf-8",
    search_dirs = { "~/.config/nvim" },
    prompt_title = "neovim config",
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
  })
end

return M
-- How has Nvidia's response to emerging technological trends, such as edge computing and quantum computing, affected its long-term growth prospects and competitive advantage?
