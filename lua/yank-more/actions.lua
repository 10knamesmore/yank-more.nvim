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

--- 复制当前缓冲区绝对路径 + 全部内容。
---@param opts BetterYankOptions
function M.yank_filepath_and_content(opts)
    local filepath = location.get_current_filepath()
    if not filepath then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local view = vim.fn.winsaveview()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local content = table.concat(lines, "\n")
    local text = filepath .. "\n" .. content

    write_register(text, opts)
    highlight.highlight_entire_buffer(opts)
    vim.fn.winrestview(view)
    vim.notify("Yanked filepath + content: " .. filepath, vim.log.levels.INFO)
end

--- 复制整个缓冲区内容。
---@param opts BetterYankOptions
function M.yank_all(opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local view = vim.fn.winsaveview()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local text = table.concat(lines, "\n")

    write_register(text, opts)
    highlight.highlight_entire_buffer(opts)
    vim.fn.winrestview(view)
    vim.notify("Yanked all buffer text", vim.log.levels.INFO)
end

--- 复制当前行代码及其诊断信息。
---@param opts BetterYankOptions
function M.yank_diagnostic(opts)
    local filepath = location.get_current_filepath()
    if not filepath then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local line_idx = line - 1

    -- 获取当前行内容
    local lines = vim.api.nvim_buf_get_lines(bufnr, line_idx, line_idx + 1, false)
    local line_content = lines[1] or ""

    -- 获取当前行的诊断信息
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line_idx })

    local text
    if #diagnostics > 0 then
        local diag_parts = {}
        for _, diag in ipairs(diagnostics) do
            local severity = vim.diagnostic.severity[diag.severity] or "UNKNOWN"
            table.insert(diag_parts, string.format("[%s] %s", severity, diag.message))
        end
        local diag_text = table.concat(diag_parts, "\n")
        text = string.format("%s:%d\n%s\n%s", filepath, line, line_content, diag_text)
    else
        text = string.format("%s:%d\n%s", filepath, line, line_content)
    end

    write_register(text, opts)
    highlight.highlight_yank_target("n", opts)
    vim.notify("Yanked line with diagnostic: " .. filepath .. ":" .. line, vim.log.levels.INFO)
end

return M
