local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    return {
        BlinkCmpMenu = { link = "Pmenu" },
        BlinkCmpMenuSelection = { link = "PmenuSel" },
        BlinkCmpLabel = { fg = "bright_grey" },
        BlinkCmpLabelMatch = { fg = "blue" },
        BlinkCmpLabelDetail = { link = "PmenuExtra" },
        BlinkCmpLabelDescription = { link = "PmenuExtra" },
        BlinkCmpSource = { fg = "dark_grey" },
        BlinkCmpMenuBorder = { link = "FloatBorder" },
        BlinkCmpKindText = { fg = "green" },
        BlinkCmpKindMethod = { fg = "blue" },
        BlinkCmpKindFunction = { fg = "blue" },
        BlinkCmpKindConstructor = { fg = "blue" },
        BlinkCmpKindField = { fg = "green" },
        BlinkCmpKindVariable = { fg = "dark_red" },
        BlinkCmpKindClass = { fg = "yellow" },
        BlinkCmpKindInterface = { fg = "yellow" },
        BlinkCmpKindModule = { fg = "blue" },
        BlinkCmpKindProperty = { fg = "blue" },
        BlinkCmpKindUnit = { fg = "green" },
        BlinkCmpKindValue = { fg = "orange" },
        BlinkCmpKindEnum = { fg = "yellow" },
        BlinkCmpKindKeyword = { fg = "purple" },
        BlinkCmpKindSnippet = { fg = "dark_red" },
        BlinkCmpKindColor = { fg = "red" },
        BlinkCmpKindFile = { fg = "blue" },
        BlinkCmpKindReference = { fg = "red" },
        BlinkCmpKindFolder = { fg = "blue" },
        BlinkCmpKindEnumMember = { fg = "cyan" },
        BlinkCmpKindConstant = { fg = "orange" },
        BlinkCmpKindStruct = { fg = "blue" },
        BlinkCmpKindEvent = { fg = "blue" },
        BlinkCmpKindOperator = { fg = "purple" },
        BlinkCmpKindTypeParameter = { fg = "dark_red" },
        BlinkCmpKindCopilot = { fg = "cyan" },
    }
end

return M
