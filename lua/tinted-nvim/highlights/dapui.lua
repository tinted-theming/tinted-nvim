local M = {}

---@param palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, aliases, cfg)
    local a = aliases
    return {
        DapUINormal = { link = "Normal" },
        DapUIVariable = { link = "Normal" },
        DapUIScope = { fg = a.blue },
        DapUIType = { fg = a.purple },
        DapUIValue = { link = "Normal" },
        DapUIModifiedValue = { fg = a.blue, bold = true },
        DapUIDecoration = { fg = a.blue },
        DapUIThread = { fg = a.green },
        DapUIStoppedThread = { fg = a.blue },
        DapUIFrameName = { link = "Normal" },
        DapUISource = { fg = a.purple },
        DapUILineNumber = { fg = a.blue },
        DapUIFloatNormal = { link = "NormalFloat" },
        DapUIFloatBorder = { link = "FloatBorder" },
        DapUIWatchesEmpty = { fg = a.red },
        DapUIWatchesValue = { fg = a.green },
        DapUIWatchesError = { fg = a.red },
        DapUIBreakpointsPath = { fg = a.blue },
        DapUIBreakpointsInfo = { fg = a.green },
        DapUIBreakpointsCurrentLine = { fg = a.green, bold = true },
        DapUIBreakpointsLine = { link = "DapUILineNumber" },
        DapUIBreakpointsDisabledLine = { fg = a.dark_grey },
        DapUICurrentFrameName = { link = "DapUIBreakpointsCurrentLine" },
        DapUIStepOver = { fg = a.blue },
        DapUIStepInto = { fg = a.blue },
        DapUIStepBack = { fg = a.blue },
        DapUIStepOut = { fg = a.blue },
        DapUIStop = { fg = a.red },
        DapUIPlayPause = { fg = a.green },
        DapUIRestart = { fg = a.green },
        DapUIUnavailable = { fg = a.dark_grey },
        DapUIWinSelect = { fg = a.blue, bold = true },
        DapUIEndofBuffer = { link = "EndOfBuffer" },
        DapUINormalNC = { link = "Normal" },
        DapUIPlayPauseNC = { fg = a.green },
        DapUIRestartNC = { fg = a.green },
        DapUIStopNC = { fg = a.red },
        DapUIUnavailableNC = { fg = a.dark_grey },
        DapUIStepOverNC = { fg = a.blue },
        DapUIStepIntoNC = { fg = a.blue },
        DapUIStepBackNC = { fg = a.blue },
        DapUIStepOutNC = { fg = a.blue },
    }
end

return M
