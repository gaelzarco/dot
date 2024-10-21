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
      border = "rounded",
      source = "always",
    },
})

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        bufnr = bufnr,
    })
end

local on_attach = function(client, bufnr)
    -- If the LSP supports formatting, set it up
    if client.supports_method('textDocument/formatting') then
        vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua lsp_formatting()
            augroup END
        ]])
    end
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

-- Fast diag hold
vim.o.updatetime = 200

-- Diags appear in floating window  
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]]

vim.cmd [[
    augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
]]
