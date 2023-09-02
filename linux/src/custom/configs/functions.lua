function _lazygit_toggle()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    hidden = true
  })
  lazygit:toggle()
end
