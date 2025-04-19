local M = {}

local function check_prerequisites()
  local ok = pcall(require, "fwatch")
  if not ok then
    vim.notify("Required plugin rktjmp/fwatch.nvim is missing.", vim.log.levels.ERROR)
    return false
  end
  return true
end

local function schedule_trigger(callback)
  vim.schedule(callback)
end

local function start_watcher(callback)
  local fwatch = require("fwatch")
  local file_path = "~/.local/share/tinted-theming/tinty/current_scheme"
  local full_path = vim.fn.expand(file_path)
  if not vim.fn.filereadable(full_path) then
    return
  end
  fwatch.watch(full_path, {
    on_event = function()
      schedule_trigger(callback)
    end,
  })
end

M.setup_live_reload = function(callback)
  local ok = check_prerequisites()
  if not ok then
    -- Required plugins aren't present. Stop.
    return
  end
  start_watcher(callback)
end

return M
