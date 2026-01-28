-- local spinner_frames = { "∙∙∙", "●∙∙", "∙●∙", "∙∙●", "∙∙∙" }
local spinner_frames = { "∙∙", "●∙", "∙●" }
local frame_idx = 1
local timer = nil

-- 停止计时器的辅助函数
local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local function get_copilot_status()
  local ok, client = pcall(require, "copilot.api")
  if not ok then
    return ""
  end

  local status = client.status.data.status
  local icons = {
    [""] = "",
    ["Normal"] = " ",
    ["Warning"] = " ",
  }

  if status == "InProgress" then
    if not timer then
      timer = vim.loop.new_timer()
      timer:start(
        0,
        150, -- interval in milliseconds
        vim.schedule_wrap(function()
          frame_idx = (frame_idx % #spinner_frames) + 1
          vim.cmd "redrawstatus" -- 强制刷新状态栏显示下一帧
        end)
      )
    end
    return spinner_frames[frame_idx]
  end

  -- 如果不是 InProgress，停止计时器并返回静态图标
  stop_timer()
  return (icons[status] or " ")
end

-- 除了最后一个路径组件外，缩短路径中的所有组件为首2个字母
local function shorten_path(path)
  local components = vim.split(path, "/")
  for i = 1, #components - 1 do
    if #components[i] > 2 then
      components[i] = components[i]:sub(1, 1)
    end
  end
  return table.concat(components, "/")
end

return {
  get_copilot_status = get_copilot_status,
  shorten_path = shorten_path,
}
