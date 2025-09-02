local M = {}

M.pick = function(arr)
  if #arr == 0 then
    return
  end
  local ns = vim.uv.hrtime() -- nvim >= 0.10
  return arr[(ns % #arr) + 1]
end

return M
