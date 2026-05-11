-- Alias name → palette tree-path resolution.
-- Aliases are a stable identifier surface for user override callbacks
-- (e.g. `fg = "red"` resolves to whatever the current scheme defines for
-- the red palette color). Internal highlight modules do NOT consume aliases;
-- they read the palette tree directly. This file exists for backwards-compat
-- with user override APIs and for terminal color slot identity.

local M = {}

-- Alias name → dotted path inside the canonical palette tree.
-- The tree is guaranteed populated for any palette returned by `colors.resolve`
-- or `colors.normalize`, so these paths resolve consistently across all three
-- scheme systems.
M.map = {
    background = "palette.black.normal", -- base00
    darkest_grey = "palette.black.bright", -- base01
    dark_grey = "palette.gray.dim", -- base02
    grey = "palette.gray.normal", -- base03
    bright_grey = "palette.gray.bright", -- base04 (Light Gray per base16 spec)
    foreground = "palette.white.normal", -- base05
    bright_white = "palette.white.dim", -- base06 (Lighter White; uses .dim slot)
    brightest_white = "palette.white.bright", -- base07

    red = "palette.red.normal", -- base08
    bright_red = "palette.red.bright", -- base12 (base24) / base08 (base16, spec-collapsed)

    orange = "palette.orange.normal", -- base09

    yellow = "palette.yellow.normal", -- base0A
    bright_yellow = "palette.yellow.bright", -- base13 / base0A

    green = "palette.green.normal", -- base0B
    bright_green = "palette.green.bright", -- base14 / base0B

    cyan = "palette.cyan.normal", -- base0C
    bright_cyan = "palette.cyan.bright", -- base15 / base0C

    blue = "palette.blue.normal", -- base0D
    bright_blue = "palette.blue.bright", -- base16 slot / base0D

    purple = "palette.magenta.normal", -- base0E
    bright_purple = "palette.magenta.bright", -- base17 / base0E

    dark_red = "palette.brown.normal", -- base0F
}

-- cterm palette indices for base16/24 (ANSI slots). Unchanged by the tree
-- migration: this is a hex → ANSI lookup keyed on the legacy slot, used by
-- utils.build_hex_to_cterm_map to attach ctermfg/ctermbg to resolved highlights.
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

---Traverse a dotted path inside a palette table.
---@param palette table
---@param path string Dotted path like "palette.red.normal"
---@return string|nil
local function lookup(palette, path)
    local cur = palette
    for part in path:gmatch("[^.]+") do
        if type(cur) ~= "table" then
            return nil
        end
        cur = cur[part]
    end
    if type(cur) == "string" then
        return cur
    end
    return nil
end

---Resolve an alias name to a hex color from the palette.
---Normalizes the input palette defensively so this works regardless of which
---shape the caller passed (legacy slots, tree, or both).
---@param name string The alias name (e.g., "red", "background")
---@param palette tinted-nvim.Palette The palette to resolve from
---@return string|nil color The hex color value, or nil if not found
function M.resolve(name, palette)
    local path = M.map[name]
    if not path then
        return nil
    end
    local colors = require("tinted-nvim.colors")
    return lookup(colors.normalize(palette), path)
end

---Build a complete alias-to-color lookup table from a palette.
---@param palette tinted-nvim.Palette The palette to build aliases from
---@return table<string, string> A table mapping alias names to hex colors
function M.build(palette)
    local colors = require("tinted-nvim.colors")
    local normalized = colors.normalize(palette)
    local out = {}
    for name in pairs(M.map) do
        local color = lookup(normalized, M.map[name])
        if color then
            out[name] = color
        end
    end
    return out
end

return M
