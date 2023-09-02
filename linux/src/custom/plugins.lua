local overrides = require("custom.configs.overrides")

local plugins = {
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "neovim/nvim-lspconfig",
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  {"akinsho/toggleterm.nvim"},

  {"williamboman/mason-lspconfig.nvim"},
}

return plugins
