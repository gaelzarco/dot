-- Basic setup
local cmp = require('cmp')
local luasnip = require('luasnip')

-- File type configuration
vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })

-- Set up nvim-autopairs
local npairs = require('nvim-autopairs')
npairs.setup({
    check_ts = true,  -- Use treesitter for better matching
    ts_config = {
        lua = {'string'},  -- Don't add pairs in lua string treesitter nodes
        javascript = {'template_string'},
        java = false,  -- Don't check treesitter on java
    },
    disable_filetype = { "TelescopePrompt" },
    fast_wrap = {
        map = '<M-e>',  -- Alt+e to use fast_wrap
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment'
    },
})

-- Set up autopairs with cmp integration
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

-- Add support for HTML/XML tags with nvim-ts-autotag if you use it
-- Uncomment if you have nvim-ts-autotag installed
require('nvim-ts-autotag').setup()

-- Completion setup
cmp.setup({
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp', keyword_length = 2 },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer', keyword_length = 2 },
        { name = 'path', keyword_length = 2 },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

-- LSP setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {'rust_analyzer', 'ts_ls', 'html', 'cssls', 'jsonls', 'yamlls', 'hyprls', 'clangd'}

-- Common LSP setup for all servers
local function setup_server(server)
    local config = { capabilities = capabilities }
    if server == 'rust_analyzer' then
        config.settings = {
            ['rust-analyzer'] = {
                assist = {
                    importGranularity = "module",
                    importPrefix = "self",
                },
                cargo = { loadOutDirsFromCheck = true },
                procMacro = { enable = true }
            }
        }
    end
    require('lspconfig')[server].setup(config)
end

-- Set up all servers
for _, server in ipairs(servers) do
    setup_server(server)
end

-- Hyprlang specific setup
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
    pattern = {"*.hl", "hypr*.conf"},
    callback = function(event)
        vim.lsp.start({
            name = "hyprlang",
            cmd = {"hyprls"},
            root_dir = vim.fn.getcwd(),
        })
    end
})

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    float = { border = "rounded", source = "always" },
})

-- LSP UI configuration
for _, handler in pairs({"hover", "signatureHelp"}) do
    vim.lsp.handlers["textDocument/" .. handler] = 
        vim.lsp.with(vim.lsp.handlers[handler], { border = "rounded" })
end

-- Autocommands for diagnostics and highlighting
vim.cmd([[
    augroup LSPConfig
        autocmd!
        autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
]])
