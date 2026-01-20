-- Build and apply terminal colors from a resolved Base16/Base24 palette.
-- Follows the official Base16/Base24 → ANSI mapping used by tinted.

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

    local term = {}

    -- Standard ANSI colors
    term[0]  = palette.base00 -- black
    term[1]  = palette.base08 -- red
    term[2]  = palette.base0B -- green
    term[3]  = palette.base0A -- yellow
    term[4]  = palette.base0D -- blue
    term[5]  = palette.base0E -- magenta
    term[6]  = palette.base0C -- cyan
    term[7]  = palette.base05 -- white

    -- Bright ANSI colors
    term[8]  = palette.base03 -- bright black
    term[9]  = palette.base12 or palette.base08 -- bright red
    term[10] = palette.base14 or palette.base0B -- bright green
    term[11] = palette.base13 or palette.base0A -- bright yellow
    term[12] = palette.base16 or palette.base0D -- bright blue
    term[13] = palette.base17 or palette.base0E -- bright magenta
    term[14] = palette.base15 or palette.base0C -- bright cyan
    term[15] = palette.base07 -- bright white

    -- Extended ANSI colors
    term[16] = palette.base09 -- orange
    term[17] = palette.base0F -- brown / extra

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
