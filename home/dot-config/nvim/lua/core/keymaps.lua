local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Telescope shortcuts
map("n", "<leader>ff", function()
    require("telescope.builtin").find_files({ hidden = true })
end, vim.tbl_extend("keep", { desc = "Find files" }, opts))

map("n", "<leader>fg", function()
    require("telescope.builtin").live_grep()
end, vim.tbl_extend("keep", { desc = "Live grep" }, opts))

map("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
end, vim.tbl_extend("keep", { desc = "List buffers" }, opts))

map("n", "<leader>fh", function()
    require("telescope.builtin").help_tags()
end, vim.tbl_extend("keep", { desc = "Help tags" }, opts))

-- Buffer navigation
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", vim.tbl_extend("keep", { desc = "Next buffer" }, opts))
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", vim.tbl_extend("keep", { desc = "Previous buffer" }, opts))
map("n", "<leader>bd", "<cmd>bdelete<cr>", vim.tbl_extend("keep", { desc = "Delete buffer" }, opts))

-- Oil file explorer
map("n", "-", "<cmd>Oil<cr>", vim.tbl_extend("keep", { desc = "Open parent directory" }, opts))
map("n", "<leader>e", "<cmd>Oil --float<cr>", vim.tbl_extend("keep", { desc = "Open Oil in floating window" }, opts))

-- Gitsigns hunks
map("n", "<leader>gs", function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
        gitsigns.stage_hunk()
    end
end, vim.tbl_extend("keep", { desc = "Stage hunk" }, opts))

map("n", "<leader>gr", function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
        gitsigns.reset_hunk()
    end
end, vim.tbl_extend("keep", { desc = "Reset hunk" }, opts))

-- LSP keymaps (set on attach in spec.lua)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Helper function for buffer-local keymaps
        local function buf_map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
        end

        -- Navigation
        buf_map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        buf_map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        buf_map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        buf_map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
        buf_map("n", "gr", vim.lsp.buf.references, "Show references")
        buf_map("n", "<leader>ls", vim.lsp.buf.signature_help, "Signature help")

        -- Diagnostics
        buf_map("n", "gl", vim.diagnostic.open_float, "Show line diagnostics")
        buf_map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        buf_map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

        -- Actions
        buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        buf_map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        buf_map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action")

        -- Hover
        buf_map("n", "K", vim.lsp.buf.hover, "Hover documentation")

        -- Telescope LSP integration
        buf_map("n", "<leader>fs", function()
            require("telescope.builtin").lsp_document_symbols()
        end, "Document symbols")

        buf_map("n", "<leader>fS", function()
            require("telescope.builtin").lsp_workspace_symbols()
        end, "Workspace symbols")

        -- Formatting
        if client and client.supports_method("textDocument/formatting") then
            buf_map("n", "<leader>fm", function()
                vim.lsp.buf.format({ async = true })
            end, "Format document")
        end

        -- Inlay hints (if supported)
        if client and client.supports_method("textDocument/inlayHint") then
            buf_map("n", "<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, "Toggle inlay hints")
        end
    end,
})

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
