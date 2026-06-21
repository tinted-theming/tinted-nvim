-- Alias name → palette tree-path resolution.
-- Aliases are a stable identifier surface for user override callbacks
-- (e.g. `fg = "red"` resolves to whatever the current scheme defines for
-- the red palette color). Internal highlight modules do NOT consume aliases;
-- they read the palette tree directly. This file exists for backwards-compat
-- with user override APIs and for terminal color slot identity.
--
local utils = require("tinted-nvim.utils")

local M = {}

-- Alias name → dotted path inside the canonical palette tree.
-- The tree is guaranteed populated for any palette returned by `colors.resolve`
-- or `colors.normalize`, so these paths resolve consistently across all three
-- scheme systems.
M.map = {
    background = "palette.black.normal",      -- base00
    darkest_gray = "palette.black.bright",    -- base01
    dark_gray = "palette.gray.dim",           -- base02
    gray = "palette.gray.normal",             -- base03
    bright_gray = "palette.gray.bright",      -- base04 (Light Gray per base16 spec)
    foreground = "palette.white.normal",      -- base05
    bright_white = "palette.white.dim",       -- base06 (Lighter White; uses .dim slot)
    brightest_white = "palette.white.bright", -- base07

    red = "palette.red.normal",               -- base08
    bright_red = "palette.red.bright",        -- base12 (base24) / base08 (base16, spec-collapsed)

    orange = "palette.orange.normal",         -- base09

    yellow = "palette.yellow.normal",         -- base0A
    bright_yellow = "palette.yellow.bright",  -- base13 / base0A

    green = "palette.green.normal",           -- base0B
    bright_green = "palette.green.bright",    -- base14 / base0B

    cyan = "palette.cyan.normal",             -- base0C
    bright_cyan = "palette.cyan.bright",      -- base15 / base0C

    blue = "palette.blue.normal",             -- base0D
    bright_blue = "palette.blue.bright",      -- base16 slot / base0D

    purple = "palette.magenta.normal",        -- base0E
    bright_purple = "palette.magenta.bright", -- base17 / base0E

    dark_red = "palette.brown.normal",        -- base0F
}

-- Tree-path → ANSI cterm slot. Used by utils.build_hex_to_cterm_map to attach
-- ctermfg/ctermbg to resolved highlights. Keyed on canonical tree paths;
-- base10/base11 (no ANSI slot) are simply absent.
--
-- Note: per the base16 styling spec, `palette.gray.normal` is ANSI 8 (Bright
-- Black) and `palette.gray.bright` is ANSI 20 (Light Gray). Tinted8-native
-- schemes route their gray color through these paths via ensure_legacy_slots'
-- inverse — meaning we treat the scheme's gray as Bright Black for terminal
-- mapping purposes, regardless of upstream system. This is a deliberate
-- "base16-convention everywhere" choice; revisit if tinted8's own ANSI
-- convention (palette.black.bright = ANSI 8) becomes load-bearing.
M.cterm = {
    ["palette.black.normal"] = 0,
    ["palette.black.bright"] = 18, -- base01 (256-color extension)
    ["palette.gray.dim"] = 19,     -- base02
    ["palette.gray.normal"] = 8,   -- base03 = ANSI Bright Black
    ["palette.gray.bright"] = 20,  -- base04 = Light Gray (256-color)
    ["palette.white.dim"] = 21,    -- base06 (256-color)
    ["palette.white.normal"] = 7,
    ["palette.white.bright"] = 15,
    ["palette.red.normal"] = 1,
    ["palette.orange.normal"] = 16, -- base09 (256-color)
    ["palette.yellow.normal"] = 3,
    ["palette.green.normal"] = 2,
    ["palette.cyan.normal"] = 6,
    ["palette.blue.normal"] = 4,
    ["palette.magenta.normal"] = 5,
    ["palette.brown.normal"] = 17, -- base0F (256-color)
    ["palette.red.bright"] = 9,
    ["palette.yellow.bright"] = 11,
    ["palette.green.bright"] = 10,
    ["palette.cyan.bright"] = 14,
    ["palette.blue.bright"] = 12,
    ["palette.magenta.bright"] = 13,
}

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
    return utils.lookup(colors.normalize(palette), path)
end

---Build a complete alias-to-color lookup table from a palette.
---@param palette tinted-nvim.Palette The palette to build aliases from
---@return table<string, string> A table mapping alias names to hex colors
function M.build(palette)
    local colors = require("tinted-nvim.colors")
    local normalized = colors.normalize(palette)
    local out = {}
    for name in pairs(M.map) do
        local color = utils.lookup(normalized, M.map[name])
        if color then
            out[name] = color
        end
    end
    return out
end

return M
