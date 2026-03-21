local M = {}
local config = require("yank-more.config")
local keymaps = require("yank-more.keymaps")

--- 初始化 better-yank.nvim。
---@param opts? BetterYankOptions
function M.setup(opts)
    local resolved = config.resolve(opts)
    M.options = resolved
    keymaps.set_keymaps(resolved)
end

return M
