local utils = require("tinted-nvim.utils")

local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, cfg)
    local ui = palette.ui
    local pal = palette.palette
    local hl = {}

    hl.Normal = {
        fg = ui.global.foreground.normal,
        bg = (cfg.ui and cfg.ui.transparent) and "NONE" or ui.global.background.normal,
    }
    if cfg.ui and cfg.ui.dim_inactive then
        local bg = (cfg.ui and cfg.ui.transparent) and "NONE"
            or utils.blend(ui.global.background.normal, "#000000", 0.2)
        hl.NormalNC = { fg = pal.gray.dim, bg = bg }
    else
        hl.NormalNC = { link = "Normal" }
    end

    hl.Cursor = { fg = ui.cursor.foreground.normal, bg = ui.cursor.background.normal }
    hl.lCursor = { link = "Cursor" }
    hl.CursorIM = { link = "Cursor" }
    hl.CursorLine = { bg = { darken = ui.highlight.line.background, amount = 0.6 } }
    hl.CursorColumn = { link = "CursorLine" }
    hl.CursorLineNr = { link = "LineNr" }

    hl.LineNr = { fg = ui.gutter.foreground }
    hl.LineNrAbove = { link = "LineNr" }
    hl.LineNrBelow = { link = "LineNr" }
    hl.SignColumn = { fg = pal.gray.bright }

    hl.ColorColumn = { bg = ui.highlight.line.background }

    hl.WinSeparator = { fg = pal.gray.dim }
    hl.VertSplit = { link = "WinSeparator" }

    hl.StatusLine = { fg = ui.chrome.foreground.normal, bg = ui.chrome.background.normal }
    hl.StatusLineNC = { link = "StatusLine" }

    hl.WinBar = { fg = ui.chrome.foreground.normal }
    hl.WinBarNC = { fg = ui.chrome.foreground.dark }

    hl.TabLine = { fg = ui.chrome.foreground.dark, bg = ui.chrome.background.dark }
    hl.TabLineSel = { fg = pal.green.normal, bg = ui.chrome.background.dark }

    hl.Visual = { bg = ui.selection.background }

    hl.MatchParen = { bg = ui.highlight.text.background }

    hl.Search = { fg = ui.highlight.search.background, bg = ui.highlight.search.foreground }
    hl.CurSearch = { link = "Search" }
    hl.IncSearch = { fg = ui.highlight.search.background, bg = pal.orange.normal }

    hl.Substitute = { fg = ui.highlight.search.background, bg = ui.highlight.search.foreground }

    hl.Pmenu = { bg = (cfg.ui and cfg.ui.transparent) and "NONE" or ui.global.background.normal }
    hl.PmenuSel = { bg = ui.selection.background }
    hl.PmenuThumb = { bg = pal.gray.dim }
    hl.PmenuKind = { link = "Pmenu" }
    hl.PmenuKindSel = { link = "PmenuSel" }
    hl.PmenuExtra = { link = "Pmenu" }
    hl.PmenuExtraSel = { link = "PmenuSel" }
    hl.PmenuSbar = { bg = pal.gray.dim }
    hl.PmenuBorder = { link = "FloatBorder" }

    hl.NonText = { fg = pal.black.bright }
    hl.SpecialKey = { fg = pal.gray.normal }
    hl.Whitespace = { link = "NonText" }
    hl.EndOfBuffer = { link = "NonText" }

    hl.Folded = { fg = pal.gray.normal }
    hl.FoldColumn = { link = "LineNr" }

    hl.Directory = { fg = pal.blue.normal }

    hl.Title = { fg = pal.blue.bright }

    hl.Error = { fg = ui.status.error }
    hl.ErrorMsg = { fg = ui.status.error }
    hl.WarningMsg = { fg = ui.status.error }

    hl.ModeMsg = { fg = pal.green.normal }
    hl.MoreMsg = { fg = pal.green.normal }
    hl.Question = { fg = pal.blue.normal }

    hl.Conceal = { fg = pal.blue.normal }

    hl.WildMenu = { fg = pal.red.normal, bg = pal.yellow.normal }

    hl.Underlined = { fg = pal.red.normal }
    hl.Ignore = { link = "NonText" }

    hl.TermCursor = { link = "Cursor" }
    hl.TermCursorNC = { link = "Cursor" }

    hl.NormalFloat = { link = "Normal" }
    hl.FloatBorder = { fg = ui.border.normal }
    hl.FloatTitle = { link = "Title" }
    hl.FloatFooter = { link = "NonText" }

    hl.QuickFixLine = { bg = ui.highlight.text.background }

    hl.SpellBad = {
        underline = not cfg.capabilities.undercurl,
        undercurl = cfg.capabilities.undercurl,
        sp = ui.status.error,
    }
    hl.SpellCap = {
        underline = not cfg.capabilities.undercurl,
        undercurl = cfg.capabilities.undercurl,
        sp = pal.orange.normal,
    }
    hl.SpellLocal = {
        underline = not cfg.capabilities.undercurl,
        undercurl = cfg.capabilities.undercurl,
        sp = pal.orange.normal,
    }
    hl.SpellRare = {
        underline = not cfg.capabilities.undercurl,
        undercurl = cfg.capabilities.undercurl,
        sp = pal.orange.normal,
    }

    hl.DiffAdd = {
        fg = ui.global.background.normal,
        bg = { darken = pal.blue.normal, amount = 0.4 },
    }
    hl.DiffText = { link = "DiffAdd" }
    hl.DiffChange = { link = "Cursorline" }
    hl.DiffDelete = { link = "NonText" }

    hl.MsgArea = { fg = ui.global.foreground.normal }
    hl.MsgSeparator = { fg = pal.gray.bright }

    hl.debugPC = { bg = pal.gray.dim }
    hl.debugBreakpoint = { fg = pal.red.normal, bg = pal.gray.dim }

    return hl
end

return M
