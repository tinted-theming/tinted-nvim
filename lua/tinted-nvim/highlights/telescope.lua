local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    return {
        TelescopeNormal       = { link = "Normal" },
        TelescopeSelection    = { link = "Visual" },
        TelescopeBorder = { link = 'FloatBorder' },
        TelescopeMatching = { fg = 'blue' },
        TelescopeTitle = { fg = 'blue' },
        TelescopeSelectionCaret = { fg = 'dark_red' },
        TelescopePreviewLine  = { link = "Visual" },
    }
end

return M
