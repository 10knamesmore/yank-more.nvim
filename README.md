# yank-more.nvim

本地使用的 Neovim 复制辅助插件，提供以下能力：

- 复制文件名
- 复制绝对路径
- 复制 `path:line`
- 复制字符可视范围 `path:r1:c1-r2:c2`
- 复制行可视范围 `path:start-end`
- 复制整个缓冲区
- 复制后高亮对应源码范围

默认映射：

- `gy`：复制文件名
- `gY`：复制绝对路径
- `<leader>yl`：复制路径位置
- `<leader>yy`：复制整个缓冲区

可通过 `setup()` 单独配置每个动作的按键与模式：

```lua
require("yank-more").setup({
  register = "+",
  mappings = {
    yank_filename = { key = "gy", mode = "n" },
    yank_filepath = { key = "gY", mode = "n" },
    yank_location = { key = "<leader>yl", mode = { "n", "x" } },
    yank_all = { key = "<leader>yy", mode = "n" },
  },
})
```
