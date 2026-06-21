-- Build and apply terminal colors from a resolved palette.
-- Reads from the canonical palette tree (`palette.palette.<color>.<variant>`)
-- so the same logic works across base16/24/tinted8. ANSI 8 (Bright Black) maps
-- to `palette.gray.normal` per the base16 spec, which assigns base03 to that role.

local M = {}

-- Build terminal color table from palette.
-- Returns nil if terminal colors are disabled.
---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return table<number, string>|nil
function M.build(palette, cfg)
    if not cfg.capabilities or not cfg.capabilities.terminal_colors then
        return nil
    end

    -- Defensive: normalize so this works regardless of which shape the caller passed.
    local colors = require("tinted-nvim.colors")
    palette = colors.normalize(palette)
    local pal = palette.palette

    local term = {}

    -- Standard ANSI colors (0-7)
    term[0] = pal.black.normal
    term[1] = pal.red.normal
    term[2] = pal.green.normal
    term[3] = pal.yellow.normal
    term[4] = pal.blue.normal
    term[5] = pal.magenta.normal
    term[6] = pal.cyan.normal
    term[7] = pal.white.normal

    -- Bright ANSI colors (8-15). For base16 schemes the .bright variants
    -- collapse to .normal per the base16 styling spec; for base24 they are
    -- distinct slots; for tinted8 the builder/scheme decides.
    term[8] = pal.black.bright -- ANSI Bright Black = base03 per base16 spec
    term[9] = pal.red.bright
    term[10] = pal.green.bright
    term[11] = pal.yellow.bright
    term[12] = pal.blue.bright
    term[13] = pal.magenta.bright
    term[14] = pal.cyan.bright
    term[15] = pal.white.bright

    -- Extended ANSI colors
    term[16] = pal.orange.normal
    term[17] = pal.brown.normal

    return term
end

-- Apply terminal colors.
---@param term table<number, string>|nil
function M.apply(term)
    if not term then
        return
    end

    for i = 0, 17 do
        local color = term[i]
        if color then
            vim.g["terminal_color_" .. i] = color
        end
    end
end

return M
