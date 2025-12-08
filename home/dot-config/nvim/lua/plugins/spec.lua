return {
    {
        "catppuccin/nvim",
        lazy = false,
        priority = 1000,
        opts = {
            integrations = {
                blink_cmp = true,
                mason = true,
                gitsigns = true,
                telescope = true,
                treesitter = true,
                which_key = true,
            },
        },
        config = function ()
            vim.cmd.colorscheme "catppuccin-mocha"
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        },
        keys = {
          {
            "<leader>?",
            function()
              require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
          },
        },
    },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ['<C-j>'] = 'move_selection_next',
                            ['<C-k>'] = 'move_selection_previous',
                        },
                    },
                },
            })
        end
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('bufferline').setup({
                options = {
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    diagnostics = "nvim_lsp",
                    separator_style = "slant",
                },
            })
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require('lualine').setup({
                options = {
                    theme = "catppuccin-mocha"
                }
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "bash",
                    "lua",
                    "vim",
                    "vimdoc",
                    "javascript",
                    "typescript",
                    "json",
                    "yaml",
                    "markdown",
                    "python",
                    "rust",
                    "go",
                    "html",
                    "css",
                    "toml",
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    -- LSP Configuration
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                -- Install these servers automatically
                ensure_installed = {
                    "lua_ls",           -- Lua
                    "rust_analyzer",    -- Rust
                    "ts_ls",            -- TypeScript/JavaScript
                    "pyright",          -- Python
                    "gopls",            -- Go
                    "bashls",           -- Bash
                    "jsonls",           -- JSON
                    "yamlls",           -- YAML
                },
                automatic_installation = true,
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            -- Get blink.cmp capabilities
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            -- Define LSP attach callback for keymaps
            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Keymaps are defined in core/keymaps.lua
            end

            -- Configure each LSP server using vim.lsp.config
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' }
                            },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        }
                    }
                },
                rust_analyzer = {},
                ts_ls = {},
                pyright = {},
                gopls = {},
                bashls = {},
                jsonls = {},
                yamlls = {},
            }

            for server_name, server_config in pairs(servers) do
                vim.lsp.config(server_name, vim.tbl_deep_extend('force', {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }, server_config))
                vim.lsp.enable(server_name)
            end
        end
    },
    -- Completion
    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = '*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = 'enter' },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },

            completion = {
                accept = {
                    auto_brackets = { enabled = true }
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200
                }
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            signature = { enabled = true },
        },
        opts_extend = { "sources.default" }
    },
    -- Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                bash = { "shfmt" },
                rust = { "rustfmt" },
                go = { "gofmt", "goimports" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        },
    },
    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                python = { "ruff" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                bash = { "shellcheck" },
            }

            -- Auto-lint on save and insert leave
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    -- File Explorer
    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                columns = {
                    "icon",
                    "permissions",
                    "size",
                    "mtime",
                },
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, bufnr)
                        return name == ".."
                    end,
                },
                float = {
                    padding = 2,
                    max_width = 0,
                    max_height = 0,
                    border = "rounded",
                },
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-s>"] = "actions.select_vsplit",
                    ["<C-h>"] = "actions.select_split",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = "actions.close",
                    ["<C-l>"] = "actions.refresh",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["`"] = "actions.cd",
                    ["~"] = "actions.tcd",
                    ["gs"] = "actions.change_sort",
                    ["gx"] = "actions.open_external",
                    ["g."] = "actions.toggle_hidden",
                    ["g\\"] = "actions.toggle_trash",
                },
            })
        end
    },
    {
        'RRethy/vim-illuminate'
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    }
}
