local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, _cfg)
    local pal = palette.palette
    return {
        BlinkCmpMenu = { link = "Pmenu" },
        BlinkCmpMenuSelection = { link = "PmenuSel" },
        BlinkCmpLabel = { fg = pal.white.dim },
        BlinkCmpLabelMatch = { fg = pal.blue.normal },
        BlinkCmpLabelDetail = { link = "PmenuExtra" },
        BlinkCmpLabelDescription = { link = "PmenuExtra" },
        BlinkCmpSource = { fg = pal.gray.dim },
        BlinkCmpMenuBorder = { link = "FloatBorder" },
        BlinkCmpKindText = { fg = pal.green.normal },
        BlinkCmpKindMethod = { fg = pal.blue.normal },
        BlinkCmpKindFunction = { fg = pal.blue.normal },
        BlinkCmpKindConstructor = { fg = pal.blue.normal },
        BlinkCmpKindField = { fg = pal.green.normal },
        BlinkCmpKindVariable = { fg = pal.brown.normal },
        BlinkCmpKindClass = { fg = pal.yellow.normal },
        BlinkCmpKindInterface = { fg = pal.yellow.normal },
        BlinkCmpKindModule = { fg = pal.blue.normal },
        BlinkCmpKindProperty = { fg = pal.blue.normal },
        BlinkCmpKindUnit = { fg = pal.green.normal },
        BlinkCmpKindValue = { fg = pal.orange.normal },
        BlinkCmpKindEnum = { fg = pal.yellow.normal },
        BlinkCmpKindKeyword = { fg = pal.magenta.normal },
        BlinkCmpKindSnippet = { fg = pal.brown.normal },
        BlinkCmpKindColor = { fg = pal.red.normal },
        BlinkCmpKindFile = { fg = pal.blue.normal },
        BlinkCmpKindReference = { fg = pal.red.normal },
        BlinkCmpKindFolder = { fg = pal.blue.normal },
        BlinkCmpKindEnumMember = { fg = pal.cyan.normal },
        BlinkCmpKindConstant = { fg = pal.orange.normal },
        BlinkCmpKindStruct = { fg = pal.blue.normal },
        BlinkCmpKindEvent = { fg = pal.blue.normal },
        BlinkCmpKindOperator = { fg = pal.magenta.normal },
        BlinkCmpKindTypeParameter = { fg = pal.brown.normal },
        BlinkCmpKindCopilot = { fg = pal.cyan.normal },
    }
end

return M
