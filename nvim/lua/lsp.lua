vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })

local npairs = require('nvim-autopairs')
npairs.setup({
    check_ts = true,
    ts_config = {
        lua = { 'string' },
        javascript = { 'template_string' },
        java = false,
    },
    disable_filetype = { "TelescopePrompt" },
    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment'
    },
})

local servers = {
    'rust_analyzer',
    'ts_ls',
    'html',
    'cssls',
    'jsonls',
    'yamlls',
    'hyprls',
    'clangd',
    'cmake',
    'pyright'
}

for _, server in ipairs(servers) do
    local config = {}
    if server == 'rust_analyzer' then
        config.settings = {
            ['rust-analyzer'] = {
                assist = { importGranularity = "module", importPrefix = "self" },
                cargo = { loadOutDirsFromCheck = true },
                procMacro = { enable = true },
            }
        }
    end
    require('lspconfig')[server].setup(config)
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { "*.hl", "hypr*.conf" },
    callback = function()
        vim.lsp.start({
            name = "hyprlang",
            cmd = { "hyprls" },
            root_dir = vim.fn.getcwd(),
        })
    end
})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    float = { border = "rounded", source = "always" },
})

for _, handler in pairs({ "hover", "signatureHelp" }) do
    vim.lsp.handlers["textDocument/" .. handler] =
        vim.lsp.with(vim.lsp.handlers[handler], { border = "rounded" })
end

vim.cmd([[
    augroup LSPConfig
        autocmd!
        autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
]])
