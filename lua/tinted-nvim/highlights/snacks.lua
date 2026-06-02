local M = {}

---@param _palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(_palette, aliases, _cfg)
    local a = aliases
    return {
        -- Dashboard
        SnacksDashboardDir = { link = "Directory" },
        SnacksDashboardFile = { fg = a.white, bold = true },
        SnacksDashboardDesc = { fg = a.white, bold = true },

        -- Picker
        SnacksPickerDir = { link = "Directory" },
        SnacksPickerFile = { link = "Normal" },
        SnacksPickerMatch = { link = "IncSearch" },
    }
end

return M
