local M = {}

local function check_prerequisites()
  local ok = pcall(require, "fwatch")
  if not ok then
    vim.notify("Required plugin rktjmp/fwatch.nvim is missing.", vim.log.levels.ERROR)
    return false
  end
  return true
end

local function trigger_autocmd()
  vim.cmd([[doautocmd User TintedReloadPost]])
end

local function schedule_trigger(callback)
  vim.schedule(callback)
  vim.schedule(trigger_autocmd)
end

local function start_watcher(callback)
  local fwatch = require("fwatch")
  local file_path = "~/.local/share/tinted-theming/tinty/current_scheme"
  local full_path = vim.fn.expand(file_path)
  if not vim.fn.filereadable(full_path) then
    return
  end
  vim.notify(full_path, vim.log.levels.INFO)
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
  schedule_trigger(callback)
  start_watcher(callback)
end

return M
