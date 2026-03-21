local M = {}

vim.hl = vim.hl or vim.highlight

local highlight_ns = vim.api.nvim_create_namespace("better-yank-highlight")
local highlight_timer = vim.uv.new_timer()

--- 获取指定行的最后一列。
---@param bufnr integer
---@param line integer
---@return integer
local function get_line_end_col(bufnr, line)
    local text = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ""
    return #text
end

--- 返回实际使用的高亮组。
---@param opts BetterYankOptions
---@return string
local function get_highlight_group(opts)
    local group = opts.highlight.group or "YankyYanked"
    if vim.fn.hlexists(group) == 0 then
        vim.api.nvim_set_hl(0, group, { link = "Search", default = true })
    end
    return group
end

--- 清除当前缓冲区中的临时高亮。
---@param bufnr integer
local function clear_highlight(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, highlight_ns, 0, -1)
end

--- 高亮整个缓冲区。
---@param opts BetterYankOptions
function M.highlight_entire_buffer(opts)
    if not opts.highlight.enabled then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local group = get_highlight_group(opts)
    local last_line = vim.api.nvim_buf_line_count(bufnr)

    highlight_timer:stop()
    clear_highlight(bufnr)

    vim.hl.range(
        bufnr,
        highlight_ns,
        group,
        { 0, 0 },
        { last_line - 1, get_line_end_col(bufnr, last_line) },
        { regtype = "V", inclusive = true }
    )

    highlight_timer:start(
        opts.highlight.timer,
        0,
        vim.schedule_wrap(function()
            clear_highlight(bufnr)
        end)
    )
end

--- 高亮本次复制对应的源码范围。
---@param mode string
---@param opts BetterYankOptions
function M.highlight_yank_target(mode, opts)
    if not opts.highlight.enabled then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local group = get_highlight_group(opts)

    highlight_timer:stop()
    clear_highlight(bufnr)

    if mode == "v" then
        local start_pos = vim.fn.getpos("v")
        local end_pos = vim.fn.getcurpos()
        local start_line, start_col = start_pos[2], start_pos[3] - 1
        local end_line, end_col = end_pos[2], end_pos[3] - 1

        if start_line > end_line or (start_line == end_line and start_col > end_col) then
            start_line, end_line = end_line, start_line
            start_col, end_col = end_col, start_col
        end

        vim.hl.range(
            bufnr,
            highlight_ns,
            group,
            { start_line - 1, start_col },
            { end_line - 1, end_col },
            { regtype = "v", inclusive = true }
        )
    elseif mode == "V" then
        local start_line = vim.fn.line("v")
        local end_line = vim.api.nvim_win_get_cursor(0)[1]
        start_line, end_line = math.min(start_line, end_line), math.max(start_line, end_line)

        vim.hl.range(
            bufnr,
            highlight_ns,
            group,
            { start_line - 1, 0 },
            { end_line - 1, get_line_end_col(bufnr, end_line) },
            { regtype = "V", inclusive = true }
        )
    else
        local line = vim.api.nvim_win_get_cursor(0)[1]
        vim.hl.range(
            bufnr,
            highlight_ns,
            group,
            { line - 1, 0 },
            { line - 1, get_line_end_col(bufnr, line) },
            { regtype = "V", inclusive = true }
        )
    end

    highlight_timer:start(
        opts.highlight.timer,
        0,
        vim.schedule_wrap(function()
            clear_highlight(bufnr)
        end)
    )
end

return M
