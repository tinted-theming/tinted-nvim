-- Serialize and load compiled highlight application.
-- Compile operates on effects, not intent.

local M = {}

local sep = package.config:sub(1, 1)

local function compiled_path(scheme)
    return table.concat({
        vim.fn.stdpath("state"),
        "tinted-nvim",
        scheme .. ".lua",
    }, sep)
end

local function compiled_dir()
    return table.concat({ vim.fn.stdpath("state"), "tinted-nvim" }, sep)
end

-- Write compiled artifact.
---@param scheme_name string
---@param palette tinted-nvim.Palette
---@param highlights table<string, tinted-nvim.Highlight>
---@param terminal? table<number, string>
function M.write(scheme_name, palette, highlights, terminal)
    local dir = compiled_dir()
    vim.fn.mkdir(dir, "p")

    local path = compiled_path(scheme_name)
    local file, err = io.open(path, "wb")
    if not file then
        error("tinted-nvim: failed to write compiled scheme: " .. err)
    end

    local inspect = vim.inspect
    local lines = {
        "return function()",
        "local g = vim.g",
        "local set = vim.api.nvim_set_hl",
    }

    -- compile highlights
    for group, spec in pairs(highlights) do
        if next(spec) ~= nil then
            table.insert(
                lines,
                string.format(
                    'set(0, "%s", %s)',
                    group,
                    inspect(spec):gsub("%s+", "")
                )
            )
        end
    end

    -- compile terminal colors
    if terminal then
        for i, color in pairs(terminal) do
            table.insert(
                lines,
                string.format(
                    'g["terminal_color_%d"] = "%s"',
                    i,
                    color
                )
            )
        end
    end

    -- compile palette
    table.insert(
        lines,
        string.format(
            "return %s",
            inspect(palette):gsub("%s+", "")
        )
    )

    table.insert(lines, "end")

    local chunk = table.concat(lines, "\n")
    local fn = assert(loadstring(chunk, "=(tinted-nvim.compile)"))
    file:write(string.dump(fn))
    file:close()
end

-- Load compiled artifact.
---@param scheme string
---@return tinted-nvim.Palette|nil
function M.load(scheme)
    local path = compiled_path(scheme)
    local fn = loadfile(path)
    if not fn then
        return nil
    end

    local apply = fn()
    return apply()
end

-- Clear all compiled artifacts.
function M.clear_all()
    local dir = compiled_dir()
    local glob = table.concat({ dir, "*.lua" }, sep)
    local files = vim.fn.glob(glob, false, true)
    for _, file in ipairs(files) do
        vim.fn.delete(file)
    end
end

-- Check if a compiled artifact exists.
---@param scheme string
---@return boolean
function M.exists(scheme)
    local path = compiled_path(scheme)
    return vim.fn.filereadable(path) == 1
end

return M
