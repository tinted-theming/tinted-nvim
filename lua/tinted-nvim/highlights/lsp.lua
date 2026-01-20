local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    local hl                       = {}

    -- LSP references
    hl.LspReferenceText            = { underline = true, sp = "bright_grey" }
    hl.LspReferenceRead            = { underline = true, sp = "bright_grey" }
    hl.LspReferenceWrite           = { underline = true, sp = "bright_grey" }

    -- Inlay hints
    hl.LspInlayHint                = { link = "Comment" }
    hl.LspSignatureActiveParameter = { link = "@parameter" }
    hl.LspCodeLens                 = { link = "Comment" }

    if vim.fn.has("nvim-0.9.0") == 1 then
        hl["@lsp.type.namespace"]                  = { link = "@namespace" }
        hl["@lsp.type.type"]                       = { link = "@type" }
        hl["@lsp.type.class"]                      = { link = "@type" }
        hl["@lsp.type.enum"]                       = { link = "@type" }
        hl["@lsp.type.interface"]                  = { link = "@type" }
        hl["@lsp.type.struct"]                     = { link = "@type" }
        hl["@lsp.type.parameter"]                  = { link = "@parameter" }
        hl["@lsp.type.variable"]                   = { link = "@variable" }
        hl["@lsp.type.property"]                   = { link = "@property" }
        hl["@lsp.type.enumMember"]                 = { link = "@constant" }
        hl["@lsp.type.function"]                   = { link = "@function" }
        hl["@lsp.type.method"]                     = { link = "@method" }
        hl["@lsp.type.macro"]                      = { link = "@function.macro" }
        hl["@lsp.type.decorator"]                  = { link = "@function" }

        hl["@lsp.type.comment"]                    = { link = "@comment" }
        hl["@lsp.type.const"]                      = { link = "@constant" }
        hl["@lsp.type.punctuation"]                = { link = "@punctuation.delimiter" }
        hl["@lsp.type.comparison"]                 = { link = "@operator" }
        hl["@lsp.type.bitwise"]                    = { link = "@operator" }
        hl["@lsp.type.selfParameter"]              = { link = "@variable.builtin" }
        hl["@lsp.type.builtinConstant"]            = { link = "@constant.builtin" }
        hl["@lsp.type.magicFunction"]              = { link = "@function.builtin" }

        hl["@lsp.mod.readonly"]                    = { link = "@constant" }
        hl["@lsp.mod.typeHint"]                    = { link = "@type" }

        hl["@lsp.typemod.operator.controlFlow"]    = { link = "@keyword.exception" }
        hl["@lsp.typemod.keyword.documentation"]   = { link = "@comment" }
        hl["@lsp.type.lifetime"]                   = { link = "@operator" }
        hl["@lsp.type.decorator.rust"]             = { link = "PreProc" }

        hl["@lsp.typemod.variable.global"]         = { link = "@constant" }
        hl["@lsp.typemod.variable.static"]         = { link = "@constant" }
        hl["@lsp.typemod.variable.defaultLibrary"] = { link = "Special" }
        hl["@lsp.typemod.variable.injected"]       = { link = "@variable" }

        hl["@lsp.typemod.function.builtin"]        = { link = "@function.builtin" }
        hl["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" }
        hl["@lsp.typemod.method.defaultLibrary"]   = { link = "@function.builtin" }
        hl["@lsp.typemod.function.readonly"]       = { link = "@function" }
    end

    return hl
end

return M
