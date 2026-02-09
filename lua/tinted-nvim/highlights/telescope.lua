local M = {}

---@param palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, aliases, cfg)
    local a = aliases
    return {
        TelescopeNormal = { link = "Normal" },
        TelescopeSelection = { link = "Visual" },
        TelescopeBorder = { link = "FloatBorder" },
        TelescopeMatching = { fg = a.blue },
        TelescopeTitle = { fg = a.blue },
        TelescopeSelectionCaret = { fg = a.dark_red },
        TelescopePreviewLine = { link = "Visual" },
    }
end

return M
