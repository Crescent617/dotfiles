local builtin_notify = vim.notify
local noti = require "notify"
local M = {}
M.timeout = 5000

local function build_key(title, msg)
  return string.format("%s:%s", title, msg)
end

local hist_msgs = {}
local msg_cnt = 0

M.notify = function(msg, level, opts)
  -- if M.blacklist ~= nil then
  --   for _, v in ipairs(M.blacklist) do
  --     if msg:find(v) then
  --       builtin_notify("[Blocked] " .. msg, vim.log.levels.INFO)
  --       return
  --     end
  --   end
  -- end

  if opts and opts.replace then
    noti(msg, level, opts)
    return
  end

  local timeout = M.timeout

  local cur_opts = opts or {}
  local cur_title = cur_opts.title or "Noti"
  cur_opts.title = cur_title

  local key = build_key(cur_title, msg)

  local last_hist = hist_msgs[key]

  local now = vim.loop.hrtime() / 1e6
  local count = 1
  if last_hist and now - last_hist.sent_at < timeout then
    count = last_hist.count + 1
    cur_opts.replace = last_hist.record
    cur_opts.title = cur_title .. " (x" .. count .. ")"
  end

  hist_msgs[key] = { sent_at = now, count = count, record = noti(msg, level, cur_opts) }

  -- clean up expired messages
  msg_cnt = msg_cnt + 1
  if msg_cnt % 10 == 0 then
    local keys_to_remove = {}

    for k, v in pairs(hist_msgs) do
      if now - v.sent_at >= timeout then
        table.insert(keys_to_remove, k)
      end
    end

    -- 删除标记的键
    for _, k in ipairs(keys_to_remove) do
      hist_msgs[k] = nil
    end
  end
end

M.setup = function(opts)
  if opts.blacklist then
    M.blacklist = opts.blacklist
  end
  if opts.timeout then
    M.timeout = opts.timeout
  end

  noti.setup {
    render = opts.render or "wrapped-compact",
    timeout = M.timeout,
  }
end

return M
