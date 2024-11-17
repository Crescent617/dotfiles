-- 定义用户命令：将 git rebase 文件中所有非注释的 pick 改为 squash（保留第一行）
vim.api.nvim_create_user_command("GitRebaseSquash", function()
  -- 获取当前缓冲区的所有行内容
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local cnt = 0
  -- 遍历行，替换 "pick" 为 "squash"（保留第一行且跳过注释行）
  for i = 2, #lines do
    -- 如果该行不是以 '#' 开头的注释行，则替换 "pick" 为 "squash"
    if not lines[i]:match "^%s*#" then
      lines[i] = lines[i]:gsub("^pick", "squash")
      cnt = cnt + 1
    end
  end

  -- 将修改后的内容写回缓冲区
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  vim.notify(string.format("Replaced %d 'pick' with 'squash'", cnt))
end, { desc = "Replace 'pick' with 'squash' in non-comment git rebase lines" })
