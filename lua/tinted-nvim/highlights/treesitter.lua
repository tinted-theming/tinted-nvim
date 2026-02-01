local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    local hl = {}

    if vim.fn.has("nvim-0.8.0") == 0 then
        -- legacy Treesitter (deprecated TS* groups)
        hl.TSAnnotation = { fg = "dark_red" }
        hl.TSAttribute = { fg = "yellow" }
        hl.TSBoolean = { fg = "orange" }
        hl.TSCharacter = { fg = "red" }
        hl.TSComment = { link = "Comment" }
        hl.TSConditional = { fg = "purple" }
        hl.TSConstant = { fg = "orange" }
        hl.TSConstBuiltin = { fg = "orange", italic = true }
        hl.TSConstMacro = { fg = "red" }
        hl.TSConstructor = { fg = "blue" }
        hl.TSError = { fg = "red" }
        hl.TSException = { fg = "red" }
        hl.TSField = { fg = "foreground" }
        hl.TSFloat = { fg = "orange" }
        hl.TSFunction = { link = "Function" }
        hl.TSFuncBuiltin = { link = "TSFunction" }
        hl.TSFuncMacro = { fg = "red" }
        hl.TSInclude = { fg = "blue" }
        hl.TSKeyword = { link = "Keyword" }
        hl.TSKeywordFunction = { link = "TSKeyword" }
        hl.TSKeywordOperator = { link = "TSKeyword" }
        hl.TSLabel = { fg = "yellow" }
        hl.TSMethod = { fg = "blue" }
        hl.TSNamespace = { fg = "red" }
        hl.TSNone = { fg = "foreground" }
        hl.TSNumber = { fg = "orange" }
        hl.TSOperator = { fg = "foreground" }
        hl.TSParameter = { fg = "foreground" }
        hl.TSParameterReference = { fg = "foreground" }
        hl.TSProperty = { fg = "foreground" }
        hl.TSPunctDelimiter = { fg = "dark_red" }
        hl.TSPunctBracket = { fg = "foreground" }
        hl.TSPunctSpecial = { fg = "dark_red" }
        hl.TSRepeat = { fg = "purple" }
        hl.TSString = { fg = "green" }
        hl.TSStringRegex = { fg = "green" }
        hl.TSStringEscape = { fg = "cyan" }
        hl.TSSymbol = { fg = "green" }
        hl.TSTag = { fg = "red" }
        hl.TSTagDelimiter = { fg = "dark_red" }
        hl.TSText = { fg = "foreground" }
        hl.TSTitle = { fg = "blue" }
        hl.TSLiteral = { fg = "orange" }
        hl.TSURI = { fg = "orange", underline = true }
        hl.TSType = { link = "Type" }
        hl.TSTypeBuiltin = { link = "TSType" }
        hl.TSVariable = { fg = "red" }
        hl.TSVariableBuiltin = { fg = "red", italic = true }
    else
        -- modern Treesitter (@ captures + semantic links)
        hl["@comment"] = { link = "Comment" }
        hl["@error"] = { fg = "red" }
        hl["@none"] = { fg = "foreground" }

        hl["@preproc"] = { fg = "yellow" }
        hl["@define"] = { fg = "purple" }
        hl["@operator"] = { fg = "foreground" }

        hl["@punctuation.delimiter"] = { fg = "dark_red" }
        hl["@punctuation.bracket"] = { fg = "foreground" }
        hl["@punctuation.special"] = { fg = "dark_red" }

        hl["@string"] = { fg = "green" }
        hl["@string.regex"] = { fg = "green" }
        hl["@string.escape"] = { fg = "cyan" }
        hl["@string.special"] = { fg = "green" }
        hl["@string.special.symbol"] = { link = "@symbol" }

        hl["@character"] = { fg = "red" }
        hl["@character.special"] = { fg = "dark_red" }

        hl["@boolean"] = { fg = "orange" }
        hl["@number"] = { fg = "orange" }
        hl["@float"] = { fg = "orange" }

        hl["@function"] = { link = "Function" }
        hl["@function.call"] = { link = "@function" }
        hl["@function.builtin"] = { link = "@function" }
        hl["@function.macro"] = { fg = "red" }

        hl["@method"] = { fg = "blue" }
        hl["@method.call"] = { link = "@method" }

        hl["@constructor"] = { fg = "blue" }

        hl["@parameter"] = { fg = "foreground" }

        hl["@keyword"] = { link = "Keyword" }
        hl["@keyword.function"] = { link = "@keyword" }
        hl["@keyword.import"] = { link = "@include" }
        hl["@keyword.operator"] = { link = "@keyword" }
        hl["@keyword.return"] = { link = "@keyword" }
        hl["@keyword.exception"] = { link = "@keyword" }

        hl["@conditional"] = { fg = "purple" }
        hl["@repeat"] = { fg = "purple" }

        hl["@label"] = { fg = "yellow" }

        hl["@include"] = { fg = "blue" }
        hl["@exception"] = { fg = "red" }

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

        hl["@storageclass"] = { fg = "yellow" }

        hl["@attribute"] = { fg = "yellow" }

        hl["@field"] = { fg = "foreground" }
        hl["@property"] = { fg = "foreground" }

        hl["@variable"] = { fg = "foreground" }
        hl["@variable.builtin"] = { fg = "foreground", italic = true }
        hl["@variable.parameter"] = { link = "@parameter" }
        hl["@variable.member"] = { link = "@field" }

        hl["@constant"] = { fg = "orange" }
        hl["@constant.builtin"] = { link = "@constant" }
        hl["@constant.macro"] = { link = "@constant" }

        hl["@namespace"] = { fg = "red" }
        hl["@module"] = { link = "@namespace" }
        hl["@module.builtin"] = { link = "@namespace" }
        hl["@symbol"] = { fg = "green" }

        if vim.fn.has("nvim-0.10") == 1 then
            hl["@markup"] = { fg = "foreground" }
            hl["@markup.heading"] = { fg = "blue" }
            hl["@markup.heading.1"] = { link = "@markup.heading" }
            hl["@markup.heading.2"] = { link = "@markup.heading" }
            hl["@markup.heading.3"] = { link = "@markup.heading" }
            hl["@markup.heading.4"] = { link = "@markup.heading" }
            hl["@markup.heading.5"] = { link = "@markup.heading" }
            hl["@markup.heading.6"] = { link = "@markup.heading" }
            hl["@markup.raw"] = { fg = "orange" }
            hl["@markup.raw.block"] = { link = "@markup.raw" }
            hl["@markup.link.url"] = { fg = "orange", underline = true }
            hl["@markup.link"] = { link = "@markup.link.url" }
            hl["@markup.link.label"] = { link = "@markup.link.url" }
            hl["@markup.list"] = { fg = "yellow" }
            hl["@markup.quote"] = { link = "@comment" }
            hl["@markup.math"] = { link = "@constant" }
            hl["@markup.environment"] = { link = "@keyword" }
            hl["@markup.strong"] = { bold = true }
            hl["@markup.emphasis"] = { italic = true }
            hl["@markup.underline"] = { underline = true }
            hl["@markup.strikethrough"] = { strikethrough = true }
            hl["@markup.todo"] = { fg = "yellow" }
            hl["@markup.warning"] = { fg = "orange" }
            hl["@markup.danger"] = { fg = "bright_red" }
            hl["@string.special.url"] = { link = "@markup.link.url" }
        else
            hl["@text"] = { fg = "foreground" }
            hl["@text.title"] = { fg = "blue" }
            hl["@text.literal"] = { fg = "orange" }
            hl["@text.uri"] = { fg = "orange", underline = true }

            hl["@text.diff.add"] = { fg = "green" }
            hl["@text.diff.delete"] = { fg = "red" }

            hl["@text.strong"] = { bold = true }
            hl["@text.emphasis"] = { italic = true }
            hl["@text.underline"] = { underline = true }
            hl["@text.strikethrough"] = { strikethrough = true }

            hl["@text.todo"] = { fg = "yellow" }
            hl["@text.warning"] = { fg = "orange" }
            hl["@text.danger"] = { fg = "bright_red" }
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
