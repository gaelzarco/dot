local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { 
            name = 'nvim_lsp',
            max_item_count = 5,  -- Limit LSP suggestions to 5
            keyword_length = 3   -- Start suggestions after 3 chars
        },
        { 
            name = 'luasnip',
            max_item_count = 5,
            keyword_length = 3
        },
        { 
            name = 'buffer',
            max_item_count = 5,
            keyword_length = 3
        },
        { 
            name = 'path',
            max_item_count = 5,
            keyword_length = 3
        },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    performance = {
        max_view_entries = 5,  -- Limit visible items to 5
    },
})

-- The capabilities setup should come AFTER cmp.setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Then set up your language servers with the capabilities
require('lspconfig').rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ['rust-analyzer'] = {
            assist = {
                importGranularity = "module",
                importPrefix = "self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

-- TypeScript/JavaScript
require('lspconfig').ts_ls.setup({
  capabilities = capabilities
})

-- HTML
require('lspconfig').html.setup({
  capabilities = capabilities
})

-- CSS
require('lspconfig').cssls.setup({
  capabilities = capabilities
})

-- JSON
require('lspconfig').jsonls.setup({
  capabilities = capabilities
})
-- YAML
require('lspconfig').yamlls.setup({
  capabilities = capabilities
})

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
vim.o.updatetime = 0

-- Diags appear in floating window  
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]]

vim.cmd [[
    augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
]]
