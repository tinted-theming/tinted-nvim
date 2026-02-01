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

return M
