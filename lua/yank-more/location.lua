local M = {}

--- 获取当前缓冲区绝对路径，不存在时给出提示。
---@return string|nil
function M.get_current_filepath()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath == "" then
        vim.notify("No file path for current buffer", vim.log.levels.WARN)
        return nil
    end

    return filepath
end

--- 生成普通模式下的 `path:line` 位置字符串。
---@param filepath string
---@return string
function M.get_normal_location(filepath)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    return string.format("%s:%d", filepath, line)
end

--- 生成字符可视模式下的 `path:r1:c1-r2:c2` 位置字符串。
---@param filepath string
---@return string
function M.get_visual_location(filepath)
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getcurpos()
    local start_line, start_col = start_pos[2], start_pos[3]
    local end_line, end_col = end_pos[2], end_pos[3]

    if start_line > end_line or (start_line == end_line and start_col > end_col) then
        start_line, end_line = end_line, start_line
        start_col, end_col = end_col, start_col
    end

    return string.format("%s:r%d:c%d-r%d:c%d", filepath, start_line, start_col, end_line, end_col)
end

--- 生成行可视模式下的 `path:start-end` 位置字符串。
---@param filepath string
---@return string
function M.get_visual_line_location(filepath)
    local start_line = vim.fn.line("v")
    local end_line = vim.api.nvim_win_get_cursor(0)[1]
    start_line, end_line = math.min(start_line, end_line), math.max(start_line, end_line)
    return string.format("%s:%d-%d", filepath, start_line, end_line)
end

--- 根据当前模式生成可复制的位置字符串。
---@return string|nil location, string mode
function M.get_yank_location()
    local filepath = M.get_current_filepath()
    if not filepath then
        return nil, vim.fn.mode()
    end

    local mode = vim.fn.mode()
    if mode == "v" then
        return M.get_visual_location(filepath), mode
    end
    if mode == "V" then
        return M.get_visual_line_location(filepath), mode
    end

    return M.get_normal_location(filepath), mode
end

return M
