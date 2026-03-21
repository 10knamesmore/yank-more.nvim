---@class BetterYankHighlightOptions
---@field enabled? boolean
---@field group? string
---@field timer? integer

---@class BetterYankMappingSpec
---@field key? string|false
---@field mode? string|string[]
---@field desc? string

---@class BetterYankMappingOptions
---@field yank_filename? BetterYankMappingSpec
---@field yank_filepath? BetterYankMappingSpec
---@field yank_location? BetterYankMappingSpec
---@field yank_all? BetterYankMappingSpec
---@field yank_filepath_and_content? BetterYankMappingSpec

---@class BetterYankOptions
---@field register? string
---@field highlight? BetterYankHighlightOptions
---@field mappings? BetterYankMappingOptions

local M = {}

M.defaults = {
    register = "+",
    highlight = {
        enabled = true,
        group = "YankyYanked",
        timer = 150,
    },
    mappings = {
        yank_filename = {
            key = "gy",
            mode = "n",
            desc = "Yank Filename",
        },
        yank_filepath = {
            key = "gY",
            mode = "n",
            desc = "Yank Absolute Path",
        },
        yank_location = {
            key = "<leader>yl",
            mode = { "n", "x" },
            desc = "Yank Path:Line/Range",
        },
        yank_all = {
            key = "<leader>yy",
            mode = "n",
            desc = "Yank All",
        },
        yank_filepath_and_content = {
            key = "<leader>yY",
            mode = "n",
            desc = "Yank Filepath + Content",
        },
    },
}

--- 合并用户配置。
---@param opts? BetterYankOptions
---@return BetterYankOptions
function M.resolve(opts)
    return vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
end

return M
