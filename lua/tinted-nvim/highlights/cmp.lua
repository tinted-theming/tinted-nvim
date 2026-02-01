local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    return {
        CmpDocumentationBorder = { link = "FloatBorder" },
        CmpDocumentation = { fg = "foreground" },
        CmpItemAbbr = { fg = "foreground", bg = "darkest_grey" },
        CmpItemAbbrDeprecated = { fg = "grey", strikethrough = true },
        CmpItemAbbrMatch = { fg = "blue" },
        CmpItemAbbrMatchFuzzy = { fg = "blue" },
        CmpItemKindDefault = { fg = "foreground" },
        CmpItemMenu = { fg = "bright_grey" },
        CmpItemKindKeyword = { fg = "purple" },
        CmpItemKindVariable = { fg = "red" },
        CmpItemKindConstant = { fg = "orange" },
        CmpItemKindReference = { fg = "red" },
        CmpItemKindValue = { fg = "orange" },
        CmpItemKindFunction = { fg = "blue" },
        CmpItemKindMethod = { fg = "blue" },
        CmpItemKindConstructor = { fg = "blue" },
        CmpItemKindClass = { fg = "yellow" },
        CmpItemKindInterface = { fg = "yellow" },
        CmpItemKindStruct = { fg = "yellow" },
        CmpItemKindEvent = { fg = "yellow" },
        CmpItemKindEnum = { fg = "yellow" },
        CmpItemKindUnit = { fg = "yellow" },
        CmpItemKindModule = { fg = "foreground" },
        CmpItemKindProperty = { fg = "red" },
        CmpItemKindField = { fg = "red" },
        CmpItemKindTypeParameter = { fg = "yellow" },
        CmpItemKindEnumMember = { fg = "yellow" },
        CmpItemKindOperator = { fg = "foreground" },
        CmpItemKindSnippet = { fg = "bright_grey" },
    }
end

return M
