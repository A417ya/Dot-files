return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  opts = {
    backends = { "treesitter", "lsp", "markdown", "man" },

    layout = {
      max_width = { 40, 0.2 },
      width = 40,
      win_width = 10,

      win_opts = {},

      default_direction = "prefer_right",

      resize_to_content = true,

      preserve_equality = false,

      placement = "window",
    },

    attach_mode = "global",

    close_automatic_events = { "unfocus", "unsupported" },
  },
  config = true,
}
