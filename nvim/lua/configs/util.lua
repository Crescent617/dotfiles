local function load_session_for_cwd()
  require("persisted").load()
  if not vim.g.persisted_loaded_session then
    vim.notify("No session found", vim.log.levels.WARN, { title = "Session" })
    return false
  else
    print("Session loaded " .. vim.g.persisted_loaded_session)
    local ft = vim.bo.filetype
    if ft == "dashboard" or ft == 'nvdash' then
      vim.cmd "bd"
    end
    return true
  end
end

return { load_session_for_cwd = load_session_for_cwd }
