-- Count the libuv handles the plugin leaves open.
--
-- `uv.walk` would be the obvious tool, but it aborts on Neovim 0.10 when it
-- meets a handle Neovim created itself. Record the handles as they are
-- created instead.

local uv = vim.uv or vim.loop

local M = {}

local constructors = { fs_event = "new_fs_event", timer = "new_timer" }
local originals = {}
local created = {}

-- Start recording handles created through `uv.new_fs_event`/`uv.new_timer`.
function M.install()
    for kind, fn in pairs(constructors) do
        created[kind] = {}
        originals[fn] = uv[fn]
        uv[fn] = function(...)
            local handle = originals[fn](...)
            if handle then
                table.insert(created[kind], handle)
            end
            return handle
        end
    end
end

-- Stop recording and put the real constructors back.
function M.restore()
    for fn, original in pairs(originals) do
        uv[fn] = original
    end
    originals = {}
    created = {}
end

-- Number of recorded handles of `kind` ("fs_event" or "timer") still open.
---@param kind string
---@return integer
function M.open(kind)
    local n = 0
    for _, handle in ipairs(created[kind] or {}) do
        if not handle:is_closing() then
            n = n + 1
        end
    end
    return n
end

return M
