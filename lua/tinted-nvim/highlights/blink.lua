local M = {}

---@param _palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(_palette, aliases, _cfg)
    local a = aliases
    return {
        BlinkCmpMenu = { link = "Pmenu" },
        BlinkCmpMenuSelection = { link = "PmenuSel" },
        BlinkCmpLabel = { fg = a.bright_grey },
        BlinkCmpLabelMatch = { fg = a.blue },
        BlinkCmpLabelDetail = { link = "PmenuExtra" },
        BlinkCmpLabelDescription = { link = "PmenuExtra" },
        BlinkCmpSource = { fg = a.dark_grey },
        BlinkCmpMenuBorder = { link = "FloatBorder" },
        BlinkCmpKindText = { fg = a.green },
        BlinkCmpKindMethod = { fg = a.blue },
        BlinkCmpKindFunction = { fg = a.blue },
        BlinkCmpKindConstructor = { fg = a.blue },
        BlinkCmpKindField = { fg = a.green },
        BlinkCmpKindVariable = { fg = a.dark_red },
        BlinkCmpKindClass = { fg = a.yellow },
        BlinkCmpKindInterface = { fg = a.yellow },
        BlinkCmpKindModule = { fg = a.blue },
        BlinkCmpKindProperty = { fg = a.blue },
        BlinkCmpKindUnit = { fg = a.green },
        BlinkCmpKindValue = { fg = a.orange },
        BlinkCmpKindEnum = { fg = a.yellow },
        BlinkCmpKindKeyword = { fg = a.purple },
        BlinkCmpKindSnippet = { fg = a.dark_red },
        BlinkCmpKindColor = { fg = a.red },
        BlinkCmpKindFile = { fg = a.blue },
        BlinkCmpKindReference = { fg = a.red },
        BlinkCmpKindFolder = { fg = a.blue },
        BlinkCmpKindEnumMember = { fg = a.cyan },
        BlinkCmpKindConstant = { fg = a.orange },
        BlinkCmpKindStruct = { fg = a.blue },
        BlinkCmpKindEvent = { fg = a.blue },
        BlinkCmpKindOperator = { fg = a.purple },
        BlinkCmpKindTypeParameter = { fg = a.dark_red },
        BlinkCmpKindCopilot = { fg = a.cyan },
    }
end

return M
