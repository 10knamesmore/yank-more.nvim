local actions = require("yank-more.actions")

local M = {}

local mapping_handlers = {
    yank_filename = actions.yank_filename,
    yank_filepath = actions.yank_filepath,
    yank_location = actions.yank_location,
    yank_all = actions.yank_all,
}

--- 注册默认按键映射。
---@param opts BetterYankOptions
function M.set_keymaps(opts)
    for name, handler in pairs(mapping_handlers) do
        local spec = opts.mappings[name]
        if spec and spec.key then
            vim.keymap.set(spec.mode, spec.key, function()
                handler(opts)
            end, { desc = spec.desc })
        end
    end
end

return M
