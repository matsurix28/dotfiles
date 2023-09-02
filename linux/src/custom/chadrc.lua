---@type ChadrcConfig

require("custom.configs.functions")

local M = {}
M.ui = {theme = 'catppucin'}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
return M
