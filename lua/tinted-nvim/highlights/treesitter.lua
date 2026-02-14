local M = {}

---@param _palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(_palette, aliases, _cfg)
    local a = aliases
    local hl = {}

    if vim.fn.has("nvim-0.8.0") == 0 then
        -- legacy Treesitter (deprecated TS* groups)
        hl.TSAnnotation = { fg = a.dark_red }
        hl.TSAttribute = { fg = a.yellow }
        hl.TSBoolean = { fg = a.orange }
        hl.TSCharacter = { fg = a.red }
        hl.TSComment = { link = "Comment" }
        hl.TSConditional = { fg = a.purple }
        hl.TSConstant = { fg = a.orange }
        hl.TSConstBuiltin = { fg = a.orange, italic = true }
        hl.TSConstMacro = { fg = a.red }
        hl.TSConstructor = { fg = a.blue }
        hl.TSError = { fg = a.red }
        hl.TSException = { fg = a.red }
        hl.TSField = { fg = a.foreground }
        hl.TSFloat = { fg = a.orange }
        hl.TSFunction = { link = "Function" }
        hl.TSFuncBuiltin = { link = "TSFunction" }
        hl.TSFuncMacro = { fg = a.red }
        hl.TSInclude = { fg = a.blue }
        hl.TSKeyword = { link = "Keyword" }
        hl.TSKeywordFunction = { link = "TSKeyword" }
        hl.TSKeywordOperator = { link = "TSKeyword" }
        hl.TSLabel = { fg = a.yellow }
        hl.TSMethod = { fg = a.blue }
        hl.TSNamespace = { fg = a.red }
        hl.TSNone = { fg = a.foreground }
        hl.TSNumber = { fg = a.orange }
        hl.TSOperator = { fg = a.foreground }
        hl.TSParameter = { fg = a.foreground }
        hl.TSParameterReference = { fg = a.foreground }
        hl.TSProperty = { fg = a.foreground }
        hl.TSPunctDelimiter = { fg = a.dark_red }
        hl.TSPunctBracket = { fg = a.foreground }
        hl.TSPunctSpecial = { fg = a.dark_red }
        hl.TSRepeat = { fg = a.purple }
        hl.TSString = { fg = a.green }
        hl.TSStringRegex = { fg = a.green }
        hl.TSStringEscape = { fg = a.cyan }
        hl.TSSymbol = { fg = a.green }
        hl.TSTag = { fg = a.red }
        hl.TSTagDelimiter = { fg = a.dark_red }
        hl.TSText = { fg = a.foreground }
        hl.TSTitle = { fg = a.blue }
        hl.TSLiteral = { fg = a.orange }
        hl.TSURI = { fg = a.orange, underline = true }
        hl.TSType = { link = "Type" }
        hl.TSTypeBuiltin = { link = "TSType" }
        hl.TSVariable = { fg = a.red }
        hl.TSVariableBuiltin = { fg = a.red, italic = true }
    else
        -- modern Treesitter (@ captures + semantic links)
        hl["@comment"] = { link = "Comment" }
        hl["@error"] = { fg = a.red }
        hl["@none"] = { fg = a.foreground }

        hl["@preproc"] = { fg = a.yellow }
        hl["@define"] = { fg = a.purple }
        hl["@operator"] = { fg = a.foreground }

        hl["@punctuation.delimiter"] = { fg = a.dark_red }
        hl["@punctuation.bracket"] = { fg = a.foreground }
        hl["@punctuation.special"] = { fg = a.dark_red }

        hl["@string"] = { fg = a.green }
        hl["@string.regex"] = { fg = a.green }
        hl["@string.escape"] = { fg = a.cyan }
        hl["@string.special"] = { fg = a.green }
        hl["@string.special.symbol"] = { link = "@symbol" }

        hl["@character"] = { fg = a.red }
        hl["@character.special"] = { fg = a.dark_red }

        hl["@boolean"] = { fg = a.orange }
        hl["@number"] = { fg = a.orange }
        hl["@float"] = { fg = a.orange }

        hl["@function"] = { link = "Function" }
        hl["@function.call"] = { link = "@function" }
        hl["@function.builtin"] = { link = "@function" }
        hl["@function.macro"] = { fg = a.red }

        hl["@method"] = { fg = a.blue }
        hl["@method.call"] = { link = "@method" }

        hl["@constructor"] = { fg = a.blue }

        hl["@parameter"] = { fg = a.foreground }

        hl["@keyword"] = { link = "Keyword" }
        hl["@keyword.function"] = { link = "@keyword" }
        hl["@keyword.import"] = { link = "@include" }
        hl["@keyword.operator"] = { link = "@keyword" }
        hl["@keyword.return"] = { link = "@keyword" }
        hl["@keyword.exception"] = { link = "@keyword" }

        hl["@conditional"] = { fg = a.purple }
        hl["@repeat"] = { fg = a.purple }

        hl["@label"] = { fg = a.yellow }

        hl["@include"] = { fg = a.blue }
        hl["@exception"] = { fg = a.red }

        hl["@type"] = { link = "Type" }
        hl["@type.builtin"] = { link = "@type" }
        hl["@type.definition"] = { link = "@type" }
        hl["@type.qualifier"] = { link = "@keyword" }

        hl["@class"] = { link = "Type" }
        hl["@struct"] = { link = "Type" }
        hl["@enum"] = { link = "Type" }
        hl["@enumMember"] = { link = "Constant" }
        hl["@event"] = { link = "Identifier" }
        hl["@interface"] = { link = "Structure" }
        hl["@modifier"] = { link = "Identifier" }
        hl["@regexp"] = { link = "@string.regex" }
        hl["@typeParameter"] = { link = "Type" }
        hl["@decorator"] = { link = "Identifier" }

        hl["@storageclass"] = { fg = a.yellow }

        hl["@attribute"] = { fg = a.yellow }

        hl["@field"] = { fg = a.foreground }
        hl["@property"] = { fg = a.foreground }

        hl["@variable"] = { fg = a.foreground }
        hl["@variable.builtin"] = { fg = a.foreground, italic = true }
        hl["@variable.parameter"] = { link = "@parameter" }
        hl["@variable.member"] = { link = "@field" }

        hl["@constant"] = { fg = a.orange }
        hl["@constant.builtin"] = { link = "@constant" }
        hl["@constant.macro"] = { link = "@constant" }

        hl["@namespace"] = { fg = a.red }
        hl["@module"] = { link = "@namespace" }
        hl["@module.builtin"] = { link = "@namespace" }
        hl["@symbol"] = { fg = a.green }

        if vim.fn.has("nvim-0.10") == 1 then
            hl["@markup"] = { fg = a.foreground }
            hl["@markup.heading"] = { fg = a.blue }
            hl["@markup.heading.1"] = { link = "@markup.heading" }
            hl["@markup.heading.2"] = { link = "@markup.heading" }
            hl["@markup.heading.3"] = { link = "@markup.heading" }
            hl["@markup.heading.4"] = { link = "@markup.heading" }
            hl["@markup.heading.5"] = { link = "@markup.heading" }
            hl["@markup.heading.6"] = { link = "@markup.heading" }
            hl["@markup.raw"] = { fg = a.orange }
            hl["@markup.raw.block"] = { link = "@markup.raw" }
            hl["@markup.link.url"] = { fg = a.orange, underline = true }
            hl["@markup.link"] = { link = "@markup.link.url" }
            hl["@markup.link.label"] = { link = "@markup.link.url" }
            hl["@markup.list"] = { fg = a.yellow }
            hl["@markup.quote"] = { link = "@comment" }
            hl["@markup.math"] = { link = "@constant" }
            hl["@markup.environment"] = { link = "@keyword" }
            hl["@markup.strong"] = { bold = true }
            hl["@markup.emphasis"] = { italic = true }
            hl["@markup.underline"] = { underline = true }
            hl["@markup.strikethrough"] = { strikethrough = true }
            hl["@markup.todo"] = { fg = a.yellow }
            hl["@markup.warning"] = { fg = a.orange }
            hl["@markup.danger"] = { fg = a.bright_red }
            hl["@string.special.url"] = { link = "@markup.link.url" }
        else
            hl["@text"] = { fg = a.foreground }
            hl["@text.title"] = { fg = a.blue }
            hl["@text.literal"] = { fg = a.orange }
            hl["@text.uri"] = { fg = a.orange, underline = true }

            hl["@text.diff.add"] = { fg = a.green }
            hl["@text.diff.delete"] = { fg = a.red }

            hl["@text.strong"] = { bold = true }
            hl["@text.emphasis"] = { italic = true }
            hl["@text.underline"] = { underline = true }
            hl["@text.strikethrough"] = { strikethrough = true }

            hl["@text.todo"] = { fg = a.yellow }
            hl["@text.warning"] = { fg = a.orange }
            hl["@text.danger"] = { fg = a.bright_red }
            hl["@string.special.url"] = { link = "@text.uri" }
        end

        hl["@comment.todo"] = { link = "Todo" }
        hl["@comment.warning"] = { link = "DiagnosticWarn" }
        hl["@comment.error"] = { link = "DiagnosticError" }
        hl["@comment.note"] = { link = "DiagnosticInfo" }
    end

    return hl
end

return M
