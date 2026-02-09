local M = {}

---@param palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, aliases, cfg)
    local a = aliases
    return {
        NotifyERRORBorder = { fg = a.red },
        NotifyWARNBorder = { fg = a.purple },
        NotifyINFOBorder = { fg = a.foreground },
        NotifyDEBUGBorder = { fg = a.cyan },
        NotifyTRACEBorder = { fg = a.cyan },

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
