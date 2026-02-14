local M = {}

---@param _palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(_palette, aliases, _cfg)
    local a = aliases
    return {
        CmpDocumentationBorder = { link = "FloatBorder" },
        CmpDocumentation = { fg = a.foreground },
        CmpItemAbbr = { fg = a.foreground, bg = a.darkest_grey },
        CmpItemAbbrDeprecated = { fg = a.grey, strikethrough = true },
        CmpItemAbbrMatch = { fg = a.blue },
        CmpItemAbbrMatchFuzzy = { fg = a.blue },
        CmpItemKindDefault = { fg = a.foreground },
        CmpItemMenu = { fg = a.bright_grey },
        CmpItemKindKeyword = { fg = a.purple },
        CmpItemKindVariable = { fg = a.red },
        CmpItemKindConstant = { fg = a.orange },
        CmpItemKindReference = { fg = a.red },
        CmpItemKindValue = { fg = a.orange },
        CmpItemKindFunction = { fg = a.blue },
        CmpItemKindMethod = { fg = a.blue },
        CmpItemKindConstructor = { fg = a.blue },
        CmpItemKindClass = { fg = a.yellow },
        CmpItemKindInterface = { fg = a.yellow },
        CmpItemKindStruct = { fg = a.yellow },
        CmpItemKindEvent = { fg = a.yellow },
        CmpItemKindEnum = { fg = a.yellow },
        CmpItemKindUnit = { fg = a.yellow },
        CmpItemKindModule = { fg = a.foreground },
        CmpItemKindProperty = { fg = a.red },
        CmpItemKindField = { fg = a.red },
        CmpItemKindTypeParameter = { fg = a.yellow },
        CmpItemKindEnumMember = { fg = a.yellow },
        CmpItemKindOperator = { fg = a.foreground },
        CmpItemKindSnippet = { fg = a.bright_grey },
    }
end

return M
