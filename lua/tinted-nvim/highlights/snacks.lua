local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, _cfg)
    local ui = palette.ui
    return {
        -- Dashboard
        SnacksDashboardDir = { link = "Directory" },
        SnacksDashboardFile = { fg = ui.global.foreground.normal, bold = true },
        SnacksDashboardDesc = { fg = ui.global.foreground.normal, bold = true },

        -- Picker
        SnacksPickerDir = { link = "Directory" },
        SnacksPickerFile = { link = "Normal" },
        SnacksPickerMatch = { link = "IncSearch" },
    }
end

return M
