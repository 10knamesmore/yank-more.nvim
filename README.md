# yank-more.nvim

`yank-more.nvim` 是一个面向日常编辑场景的 Neovim 复制辅助插件，用来快速复制当前文件的路径信息或缓冲区内容，并在复制后高亮对应源码范围。

## Why

在 CLI 里和 agent 协作时，我会发现直接把文件绝对路径(maybe 行号)复制给他, 就能很好的完成交互任务

所以只需要有个很方便的快捷键复制出来, 用终端的多tab/window就能很好的实现agent合作, 不需要任何ai插件

## Features

- 复制当前文件名
- 复制当前文件绝对路径
- 在普通模式下复制 `path:line`
- 在字符可视模式下复制 `path:r1:c1-r2:c2`
- 在行可视模式下复制 `path:start-end`
- 复制整个缓冲区内容
- 复制当前行代码及诊断信息
- 复制后短暂高亮对应行或选区
- 所有动作都可独立配置按键、模式和描述

## Requirements

- Neovim with `vim.fs`, `vim.uv` and `vim.hl.range` support

## Installation

### lazy.nvim

```lua
{
    "10knamesmore/yank-more.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        highlight = {
            timer = 150,
        },
        mappings = {
            yank_filename = { key = "gy", mode = "n" },
            yank_filepath = { key = "gY", mode = "n" },
            yank_location = { key = "<leader>yl", mode = { "n", "x" } },
            yank_all = { key = "<leader>yy", mode = "n" },
        },
    },
},
```

## Configuration

默认配置如下：

```lua
{
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
  },
}
```

配置说明：

- `register`: 写入目标寄存器，默认是系统剪贴板 `+`
- `highlight.enabled`: 是否在复制后高亮源码范围
- `highlight.group`: 使用的高亮组；不存在时会默认 link 到 `Search`
- `highlight.timer`: 高亮持续时间，单位毫秒
- `mappings.*.key`: 设置按键；设为 `false` 可禁用该映射
- `mappings.*.mode`: 对应映射模式，可为字符串或模式数组
- `mappings.*.desc`: 映射描述，会传给 `vim.keymap.set`

## Usage

### Default Mappings

- `gy`: 复制当前文件名
- `gY`: 复制当前文件绝对路径
- `<leader>yl`: 复制当前位置或可视范围位置
- `<leader>yy`: 复制整个缓冲区内容
- `<leader>yd`: 复制当前行代码及诊断信息

### Yank Location

`yank_location` 会根据当前模式自动生成不同格式：

- 普通模式: `path:line`
- 字符可视模式: `path:r1:c1-r2:c2`
- 行可视模式: `path:start-end`

示例：

```text
/tmp/demo.lua:12
/tmp/demo.lua:r12:c4-r18:c20
/tmp/demo.lua:12-18
```

### Highlight Behavior

- `yank_filename` 和 `yank_filepath` 会高亮当前行
- 普通模式下的 `yank_location` 会高亮当前行
- 可视模式下的 `yank_location` 会高亮当前选区
- `yank_all` 会高亮整个缓冲区范围

## Notes

- 当前缓冲区没有关联文件路径时，路径相关操作会直接返回并提示 `No file path for current buffer`
- `yank_location` 在可视模式执行后会自动退出选区
- 插件通过 `vim.notify()` 输出复制结果，便于确认实际写入内容

## License

MIT. See [LICENSE](/home/wanger/Documents/nvim_plugins/yank-more.nvim/LICENSE).
