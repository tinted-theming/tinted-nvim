local M = {}

local function clamp(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end

local function to_rgb(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    return r, g, b
end

local function to_hex(r, g, b)
    return string.format("#%02x%02x%02x", r, g, b)
end

function M.blend(fg, bg, amount)
    if fg:lower() == "none" then
        return "NONE"
    end
    if bg:lower() == "none" then
        return fg
    end

    local a = clamp(amount or 0, 0, 1)
    local fr, fg_, fb = to_rgb(fg)
    local br, bg_, bb = to_rgb(bg)

    local r = math.floor((fr * (1 - a)) + (br * a) + 0.5)
    local g = math.floor((fg_ * (1 - a)) + (bg_ * a) + 0.5)
    local b = math.floor((fb * (1 - a)) + (bb * a) + 0.5)

    return to_hex(r, g, b)
end

function M.darken(hex, amount, bg)
    return M.blend(hex, bg, amount)
end

function M.lighten(hex, amount, bg)
    return M.blend(hex, bg, amount)
end

function M.assert_property(table, property, error_message)
    if rawget(table, property) == nil then
        error(error_message)
    end
end

---@param color any
---@return boolean
function M.is_hex(color)
    return type(color) == "string" and color:match("^#%x%x%x%x%x%x$") ~= nil
end

---Build reverse lookup from hex color to ANSI cterm index.
---@param palette tinted-nvim.Palette
---@param cterm_map table<string, integer|nil>
---@return table<string, integer>
function M.build_hex_to_cterm_map(palette, cterm_map)
    local out = {}

    for base_key, cterm in pairs(cterm_map or {}) do
        if type(cterm) == "number" then
            local color = palette[base_key]
            if M.is_hex(color) and out[color:lower()] == nil then
                out[color:lower()] = cterm
            end
        end
    end

    return out
end

return M
