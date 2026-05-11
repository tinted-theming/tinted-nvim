local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, _cfg)
    local pal = palette.palette
    local ui = palette.ui
    return {
        CmpDocumentationBorder = { link = "FloatBorder" },
        CmpDocumentation = { fg = ui.global.foreground.normal },
        CmpItemAbbr = { fg = ui.global.foreground.normal, bg = pal.black.bright },
        CmpItemAbbrDeprecated = { fg = pal.gray.normal, strikethrough = true },
        CmpItemAbbrMatch = { fg = pal.blue.normal },
        CmpItemAbbrMatchFuzzy = { fg = pal.blue.normal },
        CmpItemKindDefault = { fg = ui.global.foreground.normal },
        CmpItemMenu = { fg = pal.white.dim },
        CmpItemKindKeyword = { fg = pal.magenta.normal },
        CmpItemKindVariable = { fg = pal.red.normal },
        CmpItemKindConstant = { fg = pal.orange.normal },
        CmpItemKindReference = { fg = pal.red.normal },
        CmpItemKindValue = { fg = pal.orange.normal },
        CmpItemKindFunction = { fg = pal.blue.normal },
        CmpItemKindMethod = { fg = pal.blue.normal },
        CmpItemKindConstructor = { fg = pal.blue.normal },
        CmpItemKindClass = { fg = pal.yellow.normal },
        CmpItemKindInterface = { fg = pal.yellow.normal },
        CmpItemKindStruct = { fg = pal.yellow.normal },
        CmpItemKindEvent = { fg = pal.yellow.normal },
        CmpItemKindEnum = { fg = pal.yellow.normal },
        CmpItemKindUnit = { fg = pal.yellow.normal },
        CmpItemKindModule = { fg = ui.global.foreground.normal },
        CmpItemKindProperty = { fg = pal.red.normal },
        CmpItemKindField = { fg = pal.red.normal },
        CmpItemKindTypeParameter = { fg = pal.yellow.normal },
        CmpItemKindEnumMember = { fg = pal.yellow.normal },
        CmpItemKindOperator = { fg = ui.global.foreground.normal },
        CmpItemKindSnippet = { fg = pal.white.dim },
    }
end

return M
