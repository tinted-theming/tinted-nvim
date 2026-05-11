local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, _cfg)
    local sx = palette.syntax
    local pal = palette.palette
    local ui = palette.ui
    local hl = {}

    if vim.fn.has("nvim-0.8.0") == 0 then
        -- legacy Treesitter (deprecated TS* groups)
        hl.TSAnnotation = { fg = pal.brown.normal }
        hl.TSAttribute = { fg = sx.entity.other["attribute-name"] }
        hl.TSBoolean = { fg = sx.constant.language }
        hl.TSCharacter = { fg = sx.constant.character.default }
        hl.TSComment = { link = "Comment" }
        hl.TSConditional = { fg = sx.keyword.control.default }
        hl.TSConstant = { fg = sx.constant.default }
        hl.TSConstBuiltin = { fg = sx.constant.default, italic = true }
        hl.TSConstMacro = { fg = pal.red.normal }
        hl.TSConstructor = { fg = sx.entity.name["function"].constructor }
        hl.TSError = { fg = ui.status.error }
        hl.TSException = { fg = pal.red.normal }
        hl.TSField = { fg = sx.variable.other.property }
        hl.TSFloat = { fg = sx.constant.numeric.float }
        hl.TSFunction = { link = "Function" }
        hl.TSFuncBuiltin = { link = "TSFunction" }
        hl.TSFuncMacro = { fg = pal.red.normal }
        hl.TSInclude = { fg = sx.keyword.control.import }
        hl.TSKeyword = { link = "Keyword" }
        hl.TSKeywordFunction = { link = "TSKeyword" }
        hl.TSKeywordOperator = { link = "TSKeyword" }
        hl.TSLabel = { fg = sx.entity.name.label }
        hl.TSMethod = { fg = sx.entity.name["function"].default }
        hl.TSNamespace = { fg = sx.entity.name.namespace }
        hl.TSNone = { fg = ui.global.foreground.normal }
        hl.TSNumber = { fg = sx.constant.numeric.default }
        hl.TSOperator = { fg = ui.global.foreground.normal }
        hl.TSParameter = { fg = sx.variable.parameter }
        hl.TSParameterReference = { fg = ui.global.foreground.normal }
        hl.TSProperty = { fg = sx.variable.other.property }
        hl.TSPunctDelimiter = { fg = sx.punctuation.separator }
        hl.TSPunctBracket = { fg = ui.global.foreground.normal }
        hl.TSPunctSpecial = { fg = sx.punctuation.section }
        hl.TSRepeat = { fg = sx.keyword.control.flow }
        hl.TSString = { fg = sx.string.default }
        hl.TSStringRegex = { fg = sx.string.regexp }
        hl.TSStringEscape = { fg = sx.constant.character.escape }
        hl.TSSymbol = { fg = pal.green.normal }
        hl.TSTag = { fg = sx.entity.name.tag }
        hl.TSTagDelimiter = { fg = sx.punctuation.separator }
        hl.TSText = { fg = ui.global.foreground.normal }
        hl.TSTitle = { fg = sx.markup.heading }
        hl.TSLiteral = { fg = sx.markup.raw }
        hl.TSURI = { fg = sx.markup.link, underline = true }
        hl.TSType = { link = "Type" }
        hl.TSTypeBuiltin = { link = "TSType" }
        hl.TSVariable = { fg = sx.variable.default }
        hl.TSVariableBuiltin = { fg = sx.variable.default, italic = true }
    else
        -- modern Treesitter (@ captures + semantic links)
        hl["@comment"] = { link = "Comment" }
        hl["@error"] = { fg = ui.status.error }
        hl["@none"] = { fg = ui.global.foreground.normal }

        hl["@preproc"] = { fg = sx.meta.preprocessor }
        hl["@define"] = { fg = sx.keyword.declaration }
        hl["@operator"] = { fg = ui.global.foreground.normal }

        hl["@punctuation.delimiter"] = { fg = sx.punctuation.separator }
        hl["@punctuation.bracket"] = { fg = ui.global.foreground.normal }
        hl["@punctuation.special"] = { fg = sx.punctuation.section }

        hl["@string"] = { fg = sx.string.default }
        hl["@string.regex"] = { fg = sx.string.regexp }
        hl["@string.escape"] = { fg = sx.constant.character.escape }
        hl["@string.special"] = { fg = sx.string.other }
        hl["@string.special.symbol"] = { link = "@symbol" }

        hl["@character"] = { fg = sx.constant.character.default }
        hl["@character.special"] = { fg = sx.punctuation.section }

        hl["@boolean"] = { fg = sx.constant.language }
        hl["@number"] = { fg = sx.constant.numeric.default }
        hl["@float"] = { fg = sx.constant.numeric.float }

        hl["@function"] = { link = "Function" }
        hl["@function.call"] = { link = "@function" }
        hl["@function.builtin"] = { link = "@function" }
        hl["@function.macro"] = { fg = pal.red.normal }

        hl["@method"] = { fg = sx.entity.name["function"].default }
        hl["@method.call"] = { link = "@method" }

        hl["@constructor"] = { fg = sx.entity.name["function"].constructor }

        hl["@parameter"] = { fg = sx.variable.parameter }

        hl["@keyword"] = { link = "Keyword" }
        hl["@keyword.function"] = { link = "@keyword" }
        hl["@keyword.import"] = { link = "@include" }
        hl["@keyword.operator"] = { link = "@keyword" }
        hl["@keyword.return"] = { link = "@keyword" }
        hl["@keyword.exception"] = { link = "@keyword" }

        hl["@conditional"] = { fg = sx.keyword.control.default }
        hl["@repeat"] = { fg = sx.keyword.control.default }

        hl["@label"] = { fg = sx.entity.name.label }

        hl["@include"] = { fg = sx.keyword.control.import }
        hl["@exception"] = { fg = pal.red.normal }

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

        hl["@storageclass"] = { fg = sx.storage.modifier }

        hl["@attribute"] = { fg = sx.entity.other["attribute-name"] }

        hl["@field"] = { fg = sx.variable.other.property }
        hl["@property"] = { fg = sx.variable.other.property }

        hl["@variable"] = { fg = sx.variable.default }
        hl["@variable.builtin"] = { fg = sx.variable.default, italic = true }
        hl["@variable.parameter"] = { link = "@parameter" }
        hl["@variable.member"] = { link = "@field" }

        hl["@constant"] = { fg = sx.constant.default }
        hl["@constant.builtin"] = { link = "@constant" }
        hl["@constant.macro"] = { link = "@constant" }

        hl["@namespace"] = { fg = sx.entity.name.namespace }
        hl["@module"] = { link = "@namespace" }
        hl["@module.builtin"] = { link = "@namespace" }
        hl["@symbol"] = { fg = pal.green.normal }

        if vim.fn.has("nvim-0.10") == 1 then
            hl["@markup"] = { fg = sx.markup.default }
            hl["@markup.heading"] = { fg = sx.markup.heading }
            hl["@markup.heading.1"] = { link = "@markup.heading" }
            hl["@markup.heading.2"] = { link = "@markup.heading" }
            hl["@markup.heading.3"] = { link = "@markup.heading" }
            hl["@markup.heading.4"] = { link = "@markup.heading" }
            hl["@markup.heading.5"] = { link = "@markup.heading" }
            hl["@markup.heading.6"] = { link = "@markup.heading" }
            hl["@markup.raw"] = { fg = sx.markup.raw }
            hl["@markup.raw.block"] = { link = "@markup.raw" }
            hl["@markup.link.url"] = { fg = sx.markup.link, underline = true }
            hl["@markup.link"] = { link = "@markup.link.url" }
            hl["@markup.link.label"] = { link = "@markup.link.url" }
            hl["@markup.list"] = { fg = sx.markup.list }
            hl["@markup.quote"] = { link = "@comment" }
            hl["@markup.math"] = { link = "@constant" }
            hl["@markup.environment"] = { link = "@keyword" }
            hl["@markup.strong"] = { bold = true }
            hl["@markup.emphasis"] = { italic = true }
            hl["@markup.underline"] = { underline = true }
            hl["@markup.strikethrough"] = { strikethrough = true }
            hl["@markup.todo"] = { fg = pal.yellow.normal }
            hl["@markup.warning"] = { fg = pal.orange.normal }
            hl["@markup.danger"] = { fg = pal.red.bright }
            hl["@string.special.url"] = { link = "@markup.link.url" }
        else
            hl["@text"] = { fg = ui.global.foreground.normal }
            hl["@text.title"] = { fg = sx.markup.heading }
            hl["@text.literal"] = { fg = sx.markup.raw }
            hl["@text.uri"] = { fg = sx.markup.link, underline = true }

            hl["@text.diff.add"] = { fg = sx.markup.inserted }
            hl["@text.diff.delete"] = { fg = sx.markup.deleted }

            hl["@text.strong"] = { bold = true }
            hl["@text.emphasis"] = { italic = true }
            hl["@text.underline"] = { underline = true }
            hl["@text.strikethrough"] = { strikethrough = true }

            hl["@text.todo"] = { fg = pal.yellow.normal }
            hl["@text.warning"] = { fg = pal.orange.normal }
            hl["@text.danger"] = { fg = pal.red.bright }
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
