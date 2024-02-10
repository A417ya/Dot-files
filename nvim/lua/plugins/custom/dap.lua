return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = { "codelldb", "debugpy" },
      automatic_installation = true,

      handlers = {
        python = function(config)
          config.adapter = {
            type = "executable",
            command = "/usr/bin/python3",
            args = {
              "-m",
              "debugpy.adapter",
            },
          }
          require("mason-nvim-dap").default_setup(config)
        end,

        codelldb = function(config)
          local rt = require("rust-tools.dap")
          -- config.adapter =
        end,
      },
    },
  },
}
