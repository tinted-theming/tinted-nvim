local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, cfg)
    local ui = palette.ui
    local pal = palette.palette
    local hl = {
        DiagnosticError = { fg = ui.status.error },
        DiagnosticWarn = { fg = ui.status.warning },
        DiagnosticInfo = { fg = ui.status.info },
        DiagnosticHint = { fg = pal.blue.normal },

        DiagnosticUnderlineError = {
            underline = not cfg.capabilities.undercurl,
            undercurl = cfg.capabilities.undercurl,
            sp = ui.status.error,
        },
        DiagnosticUnderlineWarn = {
            underline = not cfg.capabilities.undercurl,
            undercurl = cfg.capabilities.undercurl,
            sp = ui.status.warning,
        },
        DiagnosticUnderlineInfo = {
            underline = not cfg.capabilities.undercurl,
            undercurl = cfg.capabilities.undercurl,
            sp = ui.status.info,
        },
        DiagnosticUnderlineHint = {
            underline = not cfg.capabilities.undercurl,
            undercurl = cfg.capabilities.undercurl,
            sp = pal.blue.normal,
        },

        DiagnosticFloatingError = { link = "DiagnosticError" },
        DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
        DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
        DiagnosticFloatingHint = { link = "DiagnosticHint" },

        DiagnosticSignError = { link = "DiagnosticError" },
        DiagnosticSignWarn = { link = "DiagnosticWarn" },
        DiagnosticSignInfo = { link = "DiagnosticInfo" },
        DiagnosticSignHint = { link = "DiagnosticHint" },

        DiagnosticVirtualTextError = { link = "DiagnosticError" },
        DiagnosticVirtualTextWarn = { link = "DiagnosticWarn" },
        DiagnosticVirtualTextInfo = { link = "DiagnosticInfo" },
        DiagnosticVirtualTextHint = { link = "DiagnosticHint" },
    }
    if vim.fn.has("nvim-0.9.0") == 1 then
        hl.DiagnosticOk = { fg = ui.status.success }
        hl.DiagnosticUnderlineOk = {
            underline = not cfg.capabilities.undercurl,
            undercurl = cfg.capabilities.undercurl,
            sp = ui.status.success,
        }
        hl.DiagnosticFloatingOk = { link = "DiagnosticOk" }
        hl.DiagnosticSignOk = { link = "DiagnosticOk" }
        hl.DiagnosticVirtualTextOk = { link = "DiagnosticOk" }
    end
    if vim.fn.has("nvim-0.6.0") == 0 then
        hl.LspDiagnosticsDefaultError = { link = "DiagnosticError" }
        hl.LspDiagnosticsDefaultWarning = { link = "DiagnosticWarn" }
        hl.LspDiagnosticsDefaultInformation = { link = "DiagnosticInfo" }
        hl.LspDiagnosticsDefaultHint = { link = "DiagnosticHint" }
        hl.LspDiagnosticsUnderlineError = { link = "DiagnosticUnderlineError" }
        hl.LspDiagnosticsUnderlineWarning = { link = "DiagnosticUnderlineWarn" }
        hl.LspDiagnosticsUnderlineInformation = { link = "DiagnosticUnderlineInfo" }
        hl.LspDiagnosticsUnderlineHint = { link = "DiagnosticUnderlineHint" }
        hl.LspDiagnosticsVirtualTextError = { link = "DiagnosticVirtualTextError" }
        hl.LspDiagnosticsVirtualTextWarning = { link = "DiagnosticVirtualTextWarn" }
        hl.LspDiagnosticsVirtualTextInformation = { link = "DiagnosticVirtualTextInfo" }
        hl.LspDiagnosticsVirtualTextHint = { link = "DiagnosticVirtualTextHint" }
        hl.LspDiagnosticsSignError = { link = "DiagnosticSignError" }
        hl.LspDiagnosticsSignWarning = { link = "DiagnosticSignWarn" }
        hl.LspDiagnosticsSignInformation = { link = "DiagnosticSignInfo" }
        hl.LspDiagnosticsSignHint = { link = "DiagnosticSignHint" }
    end

    return hl
end

return M
