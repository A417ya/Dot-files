return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },

		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim", -- Autocomplete
			{
				"folke/lazydev.nvim",
				dependencies = { "rcarriga/nvim-dap-ui" },
				config = function()
					require("lazydev").setup({
						library = { plugins = { "nvim-dap-ui" } },
					})
				end,
			}, -- dev config for neovim
			{
				"mrcjkb/rustaceanvim",
				version = "^6", -- Recommended
				lazy = false, -- This plugin is already lazy
			},
			{
				"nvim-java/nvim-java",
				config = false,
			},
		},
		opts = {
			servers = {
				lua_ls = {},
				jsonls = {},
				dockerls = {},
				bashls = {},
				ruff = {},
				pyright = {},
				vimls = {},
				yamlls = {},
				ts_ls = {},
				html = {},
				ts_go = {},
			},

			setup = {
				pyright = function(_, opts)
					vim.lsp.config(
						"pyright",
						vim.tbl_deep_extend("force", {
							settings = {
								pyright = {
									disableOrganizeImports = true,
								},
							},
						}, opts)
					)

					-- vim.lsp.enable("pyright")
					return true
				end,
				lua_ls = function(_, opts)
					vim.lsp.config(
						"lua_ls",
						vim.tbl_deep_extend("force", {
							cmd = { "/usr/bin/lua-language-server" },
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
						}, opts)
					)
					return true
				end,
				html_lsp = function(server, opts)
					vim.lsp.config(
						server,
						vim.tbl_deep_extend("force", {
							filetypes = {
								"css",
								"html",
								"javascript",
								"javascriptreact",
								"sass",
								"scss",
								"typescriptreact",
							},
						}, opts)
					)

					-- vim.lsp.enable(server)
					return true
				end,

				ts_ls = function(server, opts)
					vim.lsp.config(
						server,
						vim.tbl_deep_extend("force", opts, {
							filetypes = {
								"html",
								"javascript",
								"javascriptreact",
								"typescriptreact",
							},
						})
					)

					-- vim.lsp.enable(server)

					return true
				end,

				jdtls = function(server, opts)
					require("java").setup(opts)
				end,

				-- emmet_ls = function(server, opts)
				--   vim.lsp.config(
				--     server,
				--     vim.tbl_deep_extend("force", {
				--       {
				--         "css",
				--         "eruby",
				--         "html",
				--         "javascript",
				--         "javascriptreact",
				--         "less",
				--         "sass",
				--         "scss",
				--         "pug",
				--         "typescriptreact",
				--       },
				--     }, opts)
				--   )

				--   return true
				-- end,

				["*"] = function(server, opts)
					vim.lsp.config(server, opts)
					-- vim.lsp.enable(server)
					return true
				end,
			},
		},

		config = function(_, opts)
			require("lazydev").setup() -- importing neodev for development support

			capabilities = require("blink.cmp").get_lsp_capabilities({
				textDocument = { completion = { completionItem = { snippetSupport = false } } },
			})

			local servers = opts.servers

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
				vim.lsp.enable(server)
			end

			-- require("mason-lspconfig").setup()

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = false,
				underline = true,
				severity_sort = false,
				float = true,
			})

			require("mason").setup({
				pip = {
					upgrade_pip = true,
				},
			})
			-- require("mason-lspconfig").setup_handlers({ setup })

			local mlsp = require("mason-lspconfig")
			local available = mlsp.get_available_servers()

			-- local mregister = require("mason-registry")
			-- local installed = mregister.get_installed_package_names()
			local mserver = mlsp.get_installed_servers()
			local ensure_installed = {} ---@type string[]

			for _, v in pairs(mserver) do
				vim.lsp.enable(v)
			end

			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run mdnual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(available, server) then
						setup(server)
					-- vim.lsp.enable(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_installation = true,
				automatic_enable = { "lua_ls", "vimls" },
			})
		end,
	},
	{
		-- "jose-elias-alvarez/null-ls.nvim",lsp.lua
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
					-- formatting.black.with({
					--   extra_args = { "--fast" },
					-- }),
					formatting.ruff,
					formatting.stylua,
					formatting.google_java_format,
					-- diagnostics.ruff,
					-- diagnostics.flake8,
					-- formatting.beautysh,
				},
			})
		end,
	},
}
