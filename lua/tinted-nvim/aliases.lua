local M = {}

M.map = {
    background = { "base00" },
    darkest_grey = { "base01" },
    dark_grey = { "base02" },
    grey = { "base03" },
    bright_grey = { "base04" },
    foreground = { "base05" },
    bright_white = { "base06" },
    brightest_white = { "base07" },

    red = { "base08" },
    bright_red = { "base12", "base08" },

    orange = { "base09" },

    yellow = { "base0A" },
    bright_yellow = { "base13", "base0A" },

    green = { "base0B" },
    bright_green = { "base14", "base0B" },

    cyan = { "base0C" },
    bright_cyan = { "base15", "base0C" },

    blue = { "base0D" },
    bright_blue = { "base16", "base0D" },

    purple = { "base0E" },
    bright_purple = { "base17", "base0E" },

    dark_red = { "base0F" },
}

-- cterm palette indices for base16/base24 (ANSI slots).
M.cterm = {
    base00 = 0,
    base01 = 18,
    base02 = 19,
    base03 = 8,
    base04 = 20,
    base05 = 7,
    base06 = 21,
    base07 = 15,
    base08 = 1,
    base09 = 16,
    base0A = 3,
    base0B = 2,
    base0C = 6,
    base0D = 4,
    base0E = 5,
    base0F = 17,
    -- base24 extended slots
    base10 = nil, -- no ANSI slot
    base11 = nil, -- no ANSI slot
    base12 = 9,
    base13 = 11,
    base14 = 10,
    base15 = 14,
    base16 = 12,
    base17 = 13,
}

---Resolve an alias name to a hex color from the palette.
---Tries each base key in order until one is found in the palette.
---@param name string The alias name (e.g., "red", "background")
---@param palette tinted-nvim.Palette The palette to resolve from
---@return string|nil color The hex color value, or nil if not found
function M.resolve(name, palette)
    local keys = M.map[name]

    if not keys then
        return nil
    end

    -- Prioritises base24 variants if they exist, otherwise falls back to base16
    for _, base in ipairs(keys) do
        local color = palette[base]
        if color then
            return color
        end
    end

    return nil
end

---Build a complete alias-to-color lookup table from a palette.
---@param palette tinted-nvim.Palette The palette to build aliases from
---@return table<string, string> A table mapping alias names to hex colors
function M.build(palette)
    local out = {}

    for name in pairs(M.map) do
        local color = M.resolve(name, palette)
        if color then
            out[name] = color
        end
    end

    return out
end

return M
