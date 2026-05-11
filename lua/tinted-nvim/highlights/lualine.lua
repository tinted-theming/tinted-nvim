local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param _cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, _cfg)
    local pal = palette.palette
    local ui = palette.ui
    local hl = {}

    hl.LualineNormalA = { fg = ui.global.background.normal, bg = pal.gray.normal, bold = true }
    hl.LualineNormalB = { fg = ui.global.foreground.normal, bg = pal.gray.dim }
    hl.LualineNormalC = { fg = pal.white.dim, bg = pal.black.bright }

    hl.LualineInsertA = { fg = ui.global.background.normal, bg = pal.blue.normal, bold = true }
    hl.LualineInsertB = { fg = ui.global.foreground.normal, bg = pal.gray.dim }
    hl.LualineInsertC = { fg = ui.global.foreground.normal, bg = pal.black.bright }

    hl.LualineVisualA = { fg = ui.global.background.normal, bg = pal.yellow.normal, bold = true }
    hl.LualineVisualB = { fg = ui.global.foreground.normal, bg = pal.gray.dim }
    hl.LualineVisualC = { fg = ui.global.foreground.normal, bg = pal.black.bright }

    hl.LualineReplaceA = { fg = ui.global.background.normal, bg = pal.red.normal, bold = true }
    hl.LualineReplaceB = { fg = ui.global.foreground.normal, bg = pal.gray.dim }
    hl.LualineReplaceC = { fg = ui.global.foreground.normal, bg = pal.black.bright }

    hl.LualineCommandA = { fg = ui.global.background.normal, bg = pal.green.normal, bold = true }
    hl.LualineCommandB = { fg = ui.global.foreground.normal, bg = pal.gray.dim }
    hl.LualineCommandC = { fg = ui.global.foreground.normal, bg = pal.black.bright }

    hl.LualineInactiveA = { fg = pal.gray.normal, bg = pal.black.bright, bold = true }
    hl.LualineInactiveB = { fg = pal.gray.normal, bg = pal.black.bright }
    hl.LualineInactiveC = { fg = pal.gray.normal, bg = pal.black.bright }

    return hl
end

return M
