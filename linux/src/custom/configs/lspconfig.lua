local config = require("plugins.configs.lspconfig")
local capabilities = config.capabilities
require("mason").setup()
require("mason-lspconfig").setup_handlers({ function (server)
  local opt = {
    capabilities = capabilities
  }
  require("lspconfig")[server].setup(opt)
end})
