local colorscheme = 'base16-black-metal-dark-funeral'

-- vim.opt.background = "dark" -- set this to dark or light

-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end

-- Uncomment the lines below to prevent overwriting transparent bg
-- vim.cmd("autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE")

-- vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
-- vim.cmd("highlight NonText guibg=NONE ctermbg=NONE")
