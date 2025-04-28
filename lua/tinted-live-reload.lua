local uv = require("luv")

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
  if vim.g.tinted_live_reload_registered then
    return
  end
  vim.g.tinted_live_reload_registered = true

  local fwatch = require("fwatch")

  -- The first line of the output is the path to the data directory.
  -- We need to watch the "current_scheme" file in that directory.
  -- The output is a list of lines, so we take the first line.
  -- The path is trimmed to remove any leading or trailing whitespace.
  -- We check if the path is not empty.
  local job = vim.fn.jobstart(
    { "tinty", "config", "--data-dir-path" },
    {
      on_stdout = function(_, data)
        if data == nil or #data == 0 then
          return
        end
        local path = vim.fn.trim(data[1])
        if #path == 0 then
          return
        end
        local file_path = vim.fn.resolve(path .. "current_scheme")
        if not vim.fn.filereadable(file_path) then
          vim.notify(string.format("File %s is not readable.", file_path), vim.log.levels.ERROR)
          return
        end
        local handle
        handle = fwatch.watch(file_path, {
          on_event = function(_, events)
            schedule_trigger(callback)

            -- Tinty 0.28+ will no longer update the current_scheme file in place. It will replace it
            -- with a new file which breaks this file watcher. We'll check whether the file moves,
            -- at which point we'll start a new watcher.
            if events.rename == true then
              -- Stop the existing watcher.
              if handle ~= nil then
                uv.fs_event_stop(handle)
              end
              -- Trigger the change
              vim.schedule(function()
                -- Reset the idempotency tracker
                vim.g.tinted_live_reload_registered = false
                -- Start a new watcher
                start_watcher(callback)
              end)
              return
            end
            schedule_trigger(callback)
          end,
        })
      end,
    }
  )
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
