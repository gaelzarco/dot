-- Rust
require('lspconfig').rust_analyzer.setup({})
-- TypeScript/JavaScript
require('lspconfig').ts_ls.setup({})
-- HTML
require('lspconfig').html.setup({})
-- CSS
require('lspconfig').cssls.setup({})
-- JSON
require('lspconfig').jsonls.setup({})
-- YAML
require('lspconfig').yamlls.setup({})

-- Diag config (global settings)
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    float = {
        source = "always",
    },
})

-- Fast diag hold
vim.o.updatetime = 200

-- Diags appear in floating window  
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]]

