--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/lsp.lua
-- Description: LSP setup and config
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
return { -- LSP - Quickstart configs for Nvim LSP
  {

    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    lazy = true,
    dependencies = { -- Mason
      -- Portable package manager for Neovim that runs everywhere Neovim runs.
      -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" }, -- Autocomplete

      -- A completion plugin for neovim coded in Lua.
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "L3MON4D3/LuaSnip",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-buffer",
          "saadparwaiz1/cmp_luasnip",
        },
      },
      {
        "folke/lazydev.nvim",
        dependencies = { "rcarriga/nvim-dap-ui" },
        config = function()
          require("lazydev").setup({
            library = { plugins = { "nvim-dap-ui" } },
          })
        end,
      }, -- dev config for neovim

      -- languages plugins
      {
        'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false,   -- This plugin is already lazy
      },
      { "pmizio/typescript-tools.nvim" },
      -- {
      --   "mrcjkb/rustaceanvim",
      --   version = "^5",
      --   lazy = false,
      --   filetype = { "rust" },
      --   config = function() end,
      -- },
    },
    opts = {
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        jsonls = {},
        dockerls = {},
        bashls = {},
        gopls = {},
        ruff = {},
        pyright = {},
        vimls = {},
        yamlls = {},
        -- rust_analyzer = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don"t want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript-tools").setup({
            server = opts
          })
          return true
        end,
        pyright = function(_, opts)
          vim.lsp.config("pyright", vim.tbl_deep_extend("force", {
            settings = {
              pyright = {
                disableOrganizeImports = true,
              },
            },
          }, opts))

          vim.lsp.enable("pyright")
          return true
        end,
        lua_ls = function(_, opts)
          vim.lsp.config("lua_ls", vim.tbl_deep_extend("force", {
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace",
                },
                workspace = {
                  checkThirdParty = false,
                },
              },
            },
          }, opts))


          return true
        end,
        svelte = function(_, opts)
          vim.lsp.config("svelte", { server = opts })
        end,

        -- rust_analyzer = function(_, opts)
        --   vim.g.rustaceanvim.server = opts
        --   -- vim.g.rustaceanvim = {
        --   --   server = opts,
        --   -- }
        --   return true
        -- end,

        -- html_lsp = function(server, opts)
        --   require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
        --     filetypes = { "html", "css", "scss" },
        --   }, opts))
        --   return true
        -- end,

        -- Specify * to use this function as a fallback for any server
        ["*"] = function(server, opts)
          vim.lsp.config(server, opts)
        end,
      },
    },
    ---@param opts Opts
    config = function(_, opts)
      require("lazydev").setup() -- importing neodev for development support

      local servers = opts.servers
      local capabilities =
          require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        vim.lsp.config(server, server_opts)
      end

      -- temp fix for lspconfig rename
      -- https://github.com/neovim/nvim-lspconfig/pull/2439
      -- local mappings = require("mason-lspconfig.mappings.server")
      -- if not mappings.lspconfig_to_package.lua_ls then, "vimls"
      --   mappings.lspconfig_to_package.lua_ls = "lua-language-server"
      --   mappings.package_to_lspconfig["lua-language-server"] = "lua_ls"
      -- end

      local mlsp = require("mason-lspconfig")
      local available = mlsp.get_available_servers()

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = false,
        float = true,
      })

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_installation = true,
        -- automatic_enable = { "rust_analyzer", "lua_ls", "vimls" }
      })
      -- require("mason-lspconfig").setup_handlers({ setup })

      -- luasnip setup
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip" })

      require("luasnip.config").set_config({
        store_selection_keys = "<tab>",
        enable_autosnippets = true,
      })

      -- nvim-cmp setup
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          {
            name = "nvim_lsp",
          },
          {
            name = "luasnip",
          },
          {
            name = "path",
          },
          {
            name = "buffer",
            option = {
              -- Avoid accidentally running on big files
              get_bufnrs = function()
                local buf = vim.api.nvim_get_current_buf()
                local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                if byte_size > 1024 * 1024 then -- 1 Megabyte max
                  return {}
                end
                return { buf }
              end,
            },
          },
        },
        view = {
          entries = "custom",
        },
      })
    end,
  }, -- Use Neovim as a language server to inject LSP diagnostics,
  -- code actions, and more via Lua.

  {
    -- "jose-elias-alvarez/null-ls.nvim",
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      local null_ls = require("null-ls")
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      local formatting = null_ls.builtins.formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      local diagnostics = null_ls.builtins.diagnostics

      null_ls.setup({
        debug = false,
        sources = {
          formatting.prettier.with({
            extra_filetypes = { "toml", "astro" },
            extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
          }),
          -- formatting.black.with({
          --   extra_args = { "--fast" },
          -- }),
          formatting.ruff,
          diagnostics.ruff,
          formatting.stylua,
          formatting.google_java_format,
          -- diagnostics.flake8,
          formatting.beautysh,
        },
      })
    end,
  },
  -- {
  --   "sbdchd/neoformat",
  --   dependencies = {
  --     "Konfekt/FastFold"
  --   },
  --   config = function() end,
  -- },
}
