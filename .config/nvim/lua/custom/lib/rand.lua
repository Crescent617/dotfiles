local M = {}

-- Return a random integer in [0, n)
M.randn = function(n)
  assert(n > 0, "n must be positive")
  local bytes = vim.uv.random(4)
  local val = 0
  for i = 1, #bytes do
    val = val * 256 + bytes:byte(i)
  end

  return (val % n)
end

-- Return a random element from an array
M.pick = function(arr)
  if #arr == 0 then
    return
  end
  return arr[M.randn(#arr) + 1]
end

return M
