local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    return {
        NotifyERRORBorder = { fg = "red" },
        NotifyWARNBorder  = { fg = "purple" },
        NotifyINFOBorder  = { fg = "foreground" },
        NotifyDEBUGBorder = { fg = "cyan" },
        NotifyTRACEBorder = { fg = "cyan" },

        NotifyERRORIcon   = { link = "NotifyERRORBorder" },
        NotifyWARNIcon    = { link = "NotifyWARNBorder" },
        NotifyINFOIcon    = { link = "NotifyINFOBorder" },
        NotifyDEBUGIcon   = { link = "NotifyDEBUGBorder" },
        NotifyTRACEIcon   = { link = "NotifyTRACEBorder" },

        NotifyERRORTitle  = { link = "NotifyERRORBorder" },
        NotifyWARNTitle   = { link = "NotifyWARNBorder" },
        NotifyINFOTitle   = { link = "NotifyINFOBorder" },
        NotifyDEBUGTitle  = { link = "NotifyDEBUGBorder" },
        NotifyTRACETitle  = { link = "NotifyTRACEBorder" },

        NotifyERRORBody   = { link = "Normal" },
        NotifyWARNBody    = { link = "Normal" },
        NotifyINFOBody    = { link = "Normal" },
        NotifyDEBUGBody   = { link = "Normal" },
        NotifyTRACEBody   = { link = "Normal" },
    }
end

return M
