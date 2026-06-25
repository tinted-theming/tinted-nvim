local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, _cfg)
    local pal = palette.palette
    return {
        TelescopeNormal = { link = "Normal" },
        TelescopeSelection = { link = "Visual" },
        TelescopeBorder = { link = "FloatBorder" },
        TelescopeMatching = { fg = pal.blue.normal },
        TelescopeTitle = { fg = pal.blue.normal },
        TelescopeSelectionCaret = { fg = pal.brown.normal },
        TelescopePreviewLine = { link = "Visual" },
    }
end

return M
