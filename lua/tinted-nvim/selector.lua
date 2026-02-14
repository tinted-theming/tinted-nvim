-- Resolve the active scheme name from an external selector.
-- Optionally watch the selector source and notify on changes.

local M = {}

local uv = vim.uv or vim.loop

local state = {
    last = nil,
    watcher = nil,
}

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
            path = vim.fn.expand(path)
            local ok, lines = pcall(vim.fn.readfile, path)
            if ok and lines and #lines > 0 then
                result = vim.fn.trim(lines[1])
            end
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

    if state.watcher then
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

    local handle = uv.new_fs_event()
    if not handle then
        return
    end

    uv.fs_event_start(handle, path, {}, function(_, _, events)
        vim.defer_fn(function()
            local current = M.resolve(cfg)
            if current and current ~= state.last then
                state.last = current
                callback(current)
            end

            -- handle file replacement (atomic write)
            if events.rename then
                uv.fs_event_stop(handle)
                state.watcher = nil
                M.watch(cfg, callback)
            end
        end, 50)
    end)

    state.watcher = handle
end

-- Stop watching (optional, future use).
function M.stop()
    if state.watcher then
        uv.fs_event_stop(state.watcher)
        state.watcher = nil
    end
end

return M
