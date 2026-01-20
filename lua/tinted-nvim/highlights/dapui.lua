local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    return {
        DapUINormal                  = { link = "Normal" },
        DapUIVariable                = { link = "Normal" },
        DapUIScope                   = { fg = "blue" },
        DapUIType                    = { fg = "purple" },
        DapUIValue                   = { link = "Normal" },
        DapUIModifiedValue           = { fg = "blue", bold = true },
        DapUIDecoration              = { fg = "blue" },
        DapUIThread                  = { fg = "green" },
        DapUIStoppedThread           = { fg = "blue" },
        DapUIFrameName               = { link = "Normal" },
        DapUISource                  = { fg = "purple" },
        DapUILineNumber              = { fg = "blue" },
        DapUIFloatNormal             = { link = "NormalFloat" },
        DapUIFloatBorder             = { link = "FloatBorder" },
        DapUIWatchesEmpty            = { fg = "red" },
        DapUIWatchesValue            = { fg = "green" },
        DapUIWatchesError            = { fg = "red" },
        DapUIBreakpointsPath         = { fg = "blue" },
        DapUIBreakpointsInfo         = { fg = "green" },
        DapUIBreakpointsCurrentLine  = { fg = "green", bold = true },
        DapUIBreakpointsLine         = { link = "DapUILineNumber" },
        DapUIBreakpointsDisabledLine = { fg = "dark_grey" },
        DapUICurrentFrameName        = { link = "DapUIBreakpointsCurrentLine" },
        DapUIStepOver                = { fg = "blue" },
        DapUIStepInto                = { fg = "blue" },
        DapUIStepBack                = { fg = "blue" },
        DapUIStepOut                 = { fg = "blue" },
        DapUIStop                    = { fg = "red" },
        DapUIPlayPause               = { fg = "green" },
        DapUIRestart                 = { fg = "green" },
        DapUIUnavailable             = { fg = "dark_grey" },
        DapUIWinSelect               = { fg = "blue", bold = true },
        DapUIEndofBuffer             = { link = "EndOfBuffer" },
        DapUINormalNC                = { link = "Normal" },
        DapUIPlayPauseNC             = { fg = "green" },
        DapUIRestartNC               = { fg = "green" },
        DapUIStopNC                  = { fg = "red" },
        DapUIUnavailableNC           = { fg = "dark_grey" },
        DapUIStepOverNC              = { fg = "blue" },
        DapUIStepIntoNC              = { fg = "blue" },
        DapUIStepBackNC              = { fg = "blue" },
        DapUIStepOutNC               = { fg = "blue" },
    }
end

return M
