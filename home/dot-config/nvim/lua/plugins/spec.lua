return {
    {
        "catppuccin/nvim",
        lazy = false,
        priority = 1000,
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
        'nvim-telescope/telescope.nvim'
    },
    {
        "akinsho/bufferline.nvim",
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
        build = ":TSUpdate"
    }
}