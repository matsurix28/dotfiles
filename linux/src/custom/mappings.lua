local M = {}
M.key = {
  n = {
    ["lg"] = {"<cmd>lua _lazygit_toggle()<CR>", "lazygit"},
    ["tt"] = {"<cmd>terminal<CR>i", "terminal"},
  },
  t = {
    ["<ESC>"] = {"<C-\\><C-n>", "escape terminal"},
  }
}

return M
