return {
  "olimorris/onedarkpro.nvim",
  priority = 1000, -- Ensure it loads first
  config = function()
    vim.cmd([[
augroup TransparentBackground
autocmd!
autocmd ColorScheme * highlight Normal ctermbg=none guibg=none
autocmd ColorScheme * highlight NonText ctermbg=none guibg=none
augroup END
]])
vim.cmd("colorscheme onedark")
  end
}

-- somewhere in your config:
