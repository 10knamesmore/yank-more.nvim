local highlight = require("yank-more.highlight")
local location = require("yank-more.location")

local M = {}

--- 将文本写入目标寄存器。
---@param text string
---@param opts BetterYankOptions
local function write_register(text, opts)
    vim.fn.setreg(opts.register, text)
end

--- 复制当前缓冲区文件名。
---@param opts BetterYankOptions
function M.yank_filename(opts)
    local filepath = location.get_current_filepath()
    if not filepath then
        return
    end

    local filename = vim.fs.basename(filepath)
    write_register(filename, opts)
    highlight.highlight_yank_target("n", opts)
    vim.notify("Yanked filename: " .. filename, vim.log.levels.INFO)
end

--- 复制当前缓冲区绝对路径。
---@param opts BetterYankOptions
function M.yank_filepath(opts)
    local filepath = location.get_current_filepath()
    if not filepath then
        return
    end

    write_register(filepath, opts)
    highlight.highlight_yank_target("n", opts)
    vim.notify("Yanked absolute path: " .. filepath, vim.log.levels.INFO)
end

--- 复制当前路径位置信息。
---@param opts BetterYankOptions
function M.yank_location(opts)
    local result, mode = location.get_yank_location()
    if not result then
        return
    end

    write_register(result, opts)
    highlight.highlight_yank_target(mode, opts)
    if mode == "v" or mode == "V" then
        vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
    end
    vim.notify("Yanked path with line: " .. result, vim.log.levels.INFO)
end

--- 复制整个缓冲区内容。
---@param opts BetterYankOptions
function M.yank_all(opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local view = vim.fn.winsaveview()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local text = table.concat(lines, "\n")

    write_register(text, opts)
    highlight.highlight_yank_target("V", opts)
    vim.fn.winrestview(view)
    vim.notify("Yanked all buffer text", vim.log.levels.INFO)
end

return M
