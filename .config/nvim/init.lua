vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.nu = true
vim.o.autoread = true
vim.o.undodir = "~/.config/nvim/undodir"
vim.o.undofile = true

-- Custom colorscheme
vim.api.nvim_set_hl(0, "Normal", { fg = "#d8dee9", bg = "#2e3440" })
