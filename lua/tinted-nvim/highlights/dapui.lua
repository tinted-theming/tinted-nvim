local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, _cfg)
    local pal = palette.palette
    return {
        DapUINormal = { link = "Normal" },
        DapUIVariable = { link = "Normal" },
        DapUIScope = { fg = pal.blue.normal },
        DapUIType = { fg = pal.magenta.normal },
        DapUIValue = { link = "Normal" },
        DapUIModifiedValue = { fg = pal.blue.normal, bold = true },
        DapUIDecoration = { fg = pal.blue.normal },
        DapUIThread = { fg = pal.green.normal },
        DapUIStoppedThread = { fg = pal.blue.normal },
        DapUIFrameName = { link = "Normal" },
        DapUISource = { fg = pal.magenta.normal },
        DapUILineNumber = { fg = pal.blue.normal },
        DapUIFloatNormal = { link = "NormalFloat" },
        DapUIFloatBorder = { link = "FloatBorder" },
        DapUIWatchesEmpty = { fg = pal.red.normal },
        DapUIWatchesValue = { fg = pal.green.normal },
        DapUIWatchesError = { fg = pal.red.normal },
        DapUIBreakpointsPath = { fg = pal.blue.normal },
        DapUIBreakpointsInfo = { fg = pal.green.normal },
        DapUIBreakpointsCurrentLine = { fg = pal.green.normal, bold = true },
        DapUIBreakpointsLine = { link = "DapUILineNumber" },
        DapUIBreakpointsDisabledLine = { fg = pal.gray.dim },
        DapUICurrentFrameName = { link = "DapUIBreakpointsCurrentLine" },
        DapUIStepOver = { fg = pal.blue.normal },
        DapUIStepInto = { fg = pal.blue.normal },
        DapUIStepBack = { fg = pal.blue.normal },
        DapUIStepOut = { fg = pal.blue.normal },
        DapUIStop = { fg = pal.red.normal },
        DapUIPlayPause = { fg = pal.green.normal },
        DapUIRestart = { fg = pal.green.normal },
        DapUIUnavailable = { fg = pal.gray.dim },
        DapUIWinSelect = { fg = pal.blue.normal, bold = true },
        DapUIEndofBuffer = { link = "EndOfBuffer" },
        DapUINormalNC = { link = "Normal" },
        DapUIPlayPauseNC = { fg = pal.green.normal },
        DapUIRestartNC = { fg = pal.green.normal },
        DapUIStopNC = { fg = pal.red.normal },
        DapUIUnavailableNC = { fg = pal.gray.dim },
        DapUIStepOverNC = { fg = pal.blue.normal },
        DapUIStepIntoNC = { fg = pal.blue.normal },
        DapUIStepBackNC = { fg = pal.blue.normal },
        DapUIStepOutNC = { fg = pal.blue.normal },
    }
end

return M
