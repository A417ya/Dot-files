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
}
