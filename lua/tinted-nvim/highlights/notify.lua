local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, _cfg)
    local pal = palette.palette
    local ui = palette.ui
    return {
        NotifyERRORBorder = { fg = ui.status.error },
        NotifyWARNBorder = { fg = pal.magenta.normal },
        NotifyINFOBorder = { fg = ui.global.foreground.normal },
        NotifyDEBUGBorder = { fg = pal.cyan.normal },
        NotifyTRACEBorder = { fg = pal.cyan.normal },

        NotifyERRORIcon = { link = "NotifyERRORBorder" },
        NotifyWARNIcon = { link = "NotifyWARNBorder" },
        NotifyINFOIcon = { link = "NotifyINFOBorder" },
        NotifyDEBUGIcon = { link = "NotifyDEBUGBorder" },
        NotifyTRACEIcon = { link = "NotifyTRACEBorder" },

        NotifyERRORTitle = { link = "NotifyERRORBorder" },
        NotifyWARNTitle = { link = "NotifyWARNBorder" },
        NotifyINFOTitle = { link = "NotifyINFOBorder" },
        NotifyDEBUGTitle = { link = "NotifyDEBUGBorder" },
        NotifyTRACETitle = { link = "NotifyTRACEBorder" },

        NotifyERRORBody = { link = "Normal" },
        NotifyWARNBody = { link = "Normal" },
        NotifyINFOBody = { link = "Normal" },
        NotifyDEBUGBody = { link = "Normal" },
        NotifyTRACEBody = { link = "Normal" },
    }
end

return M
