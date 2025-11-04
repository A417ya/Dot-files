return {
  {
    "lervag/vimtex",
    filetype = "tex",
    config = function()
      vim.g.tex_flavour = "latex"
      -- vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
      vim.opt.conceallevel = 1
      vim.g.tex_conceal = "abdmg"
      vim.g.tex_compiles_successfully = false
      vim.g.term_pdf_vierer_open = false
      vim.cmd([[
      :set noautoindent
      :set nocindent
      :set nosmartindent
      :set indentexpr=
      ]])
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  {
    "echaya/neowiki.nvim",
    opts = {
      wiki_dirs = {
        -- neowiki.nvim supports both absolute and relative paths
        { name = "Work",     path = "~/work/wiki" },
        { name = "Personal", path = "personal/wiki" },
      },
    },
    keys = {
      { "<leader>ww", "<cmd>lua require('neowiki').open_wiki()<cr>",          desc = "Open Wiki" },
      { "<leader>wW", "<cmd>lua require('neowiki').open_wiki_floating()<cr>", desc = "Open Floating Wiki" },
      { "<leader>wT", "<cmd>lua require('neowiki').open_wiki_new_tab()<cr>",  desc = "Open Wiki in Tab" },
    },
  }
}
