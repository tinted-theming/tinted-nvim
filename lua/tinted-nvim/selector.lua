-- Resolve the active scheme name from an external selector.
-- Optionally watch the selector source and notify on changes.

local M = {}

local uv = vim.uv or vim.loop

-- Wait this long after the last filesystem event before acting, so a burst
-- of events is handled once.
local DEBOUNCE_MS = 50

-- When the file is being replaced it can be missing for a moment. Retry
-- re-arming the watcher at this interval, up to this many times (~2s).
local REARM_RETRY_MS = 50
local REARM_MAX_RETRIES = 40

-- The watcher state lives in a global rather than in this module, so that it
-- survives the module being reloaded (`package.loaded` cleared by a plugin
-- manager's hot reload, for instance). A fresh module-local table would lose
-- track of the running watcher and start a second one next to it.
local STATE_KEY = "__tinted_nvim_selector_state"

local state = rawget(_G, STATE_KEY)
if not state then
    state = {
        last = nil,
        -- fs_event handle; nil while waiting to re-arm
        watcher = nil,
        -- debounce/retry timer; non-nil for as long as we are watching
        timer = nil,
    }
    rawset(_G, STATE_KEY, state)
end

---@param handle any A libuv handle, or nil.
local function close(handle)
    if handle and not handle:is_closing() then
        handle:close()
    end
end

-- Read the scheme name from a selector file.
-- Returns nil when the file is missing, unreadable or empty.
---@param path string
---@return string|nil
local function read_scheme(path)
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok or not lines or #lines == 0 then
        return nil
    end
    local name = vim.fn.trim(lines[1])
    if name == "" then
        return nil
    end
    return name
end

-- Resolve scheme name according to selector config.
---@param cfg tinted-nvim.Config
---@return string|nil
function M.resolve(cfg)
    local sel = cfg.selector
    if not sel or not sel.enabled then
        return cfg.default_scheme
    end

    local result = nil

    if sel.mode == "file" then
        local path = sel.path
        if path and path ~= "" then
            result = read_scheme(vim.fn.expand(path))
        end
    elseif sel.mode == "env" then
        local val = vim.env[sel.env]
        if val and val ~= "" then
            result = vim.fn.trim(val)
        end
    elseif sel.mode == "cmd" then
        local out = vim.fn.system(sel.cmd)
        if vim.v.shell_error == 0 and out then
            result = vim.fn.trim(out)
        end
    end

    if not result or result == "" then
        return cfg.default_scheme
    end

    return result
end

-- Start watching the selector source.
-- Calls `callback(new_scheme)` when the resolved scheme changes.
---@param cfg tinted-nvim.Config
---@param callback fun(name:string)
function M.watch(cfg, callback)
    local sel = cfg.selector
    if not sel or not sel.enabled or not sel.watch then
        return
    end

    -- Only file mode is watchable
    if sel.mode ~= "file" then
        return
    end

    if state.timer then
        return
    end

    local path = sel.path
    if not path or path == "" then
        return
    end
    path = vim.fn.expand(path)

    if state.last == nil then
        state.last = M.resolve(cfg)
    end

    local timer = uv.new_timer()
    if not timer then
        return
    end

    -- Set when the watched file was deleted or replaced. The handle is bound
    -- to the old file, so it has to be swapped for one on the new file.
    local needs_rearm = false
    local retries = 0
    local settle

    local function on_event(err, _, events)
        if err or (events and events.rename) then
            needs_rearm = true
        end
        -- Restarting the one timer coalesces bursts: replacing a file can
        -- deliver several events, and they must lead to a single re-arm.
        timer:start(DEBOUNCE_MS, 0, settle)
    end

    ---@return any handle The started fs_event handle, or nil on failure.
    local function arm()
        local handle = uv.new_fs_event()
        if not handle then
            return nil
        end
        if not uv.fs_event_start(handle, path, {}, on_event) then
            close(handle)
            return nil
        end
        return handle
    end

    settle = vim.schedule_wrap(function()
        -- stopped while this call was queued
        if state.timer ~= timer then
            return
        end

        if needs_rearm then
            close(state.watcher)
            state.watcher = arm()

            if state.watcher then
                needs_rearm = false
                retries = 0
            elseif retries < REARM_MAX_RETRIES then
                retries = retries + 1
                timer:start(REARM_RETRY_MS, 0, settle)
            else
                M.stop()
                vim.notify(
                    ("tinted-nvim: stopped watching %s, the file no longer exists"):format(path),
                    vim.log.levels.WARN
                )
                return
            end
        end

        -- Read after re-arming so a write that lands in between is not missed.
        -- A missing or empty file means a write is in progress: keep the
        -- current scheme rather than falling back to the default.
        local current = read_scheme(path)
        if current and current ~= state.last then
            state.last = current
            callback(current)
        end
    end)

    state.watcher = arm()
    if not state.watcher then
        close(timer)
        return
    end
    state.timer = timer
end

-- Stop watching and release the watcher's handles.
function M.stop()
    close(state.watcher)
    close(state.timer)
    state.watcher = nil
    state.timer = nil
    -- the next watch() may be for a different file
    state.last = nil
end

return M
