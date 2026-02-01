local utils = require("tinted-nvim.utils")

local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    local hl = {}

    hl.Normal = { fg = "foreground", bg = (cfg.ui and cfg.ui.transparent) and "NONE" or "background" }
    if cfg.ui and cfg.ui.dim_inactive then
        local bg = (cfg.ui and cfg.ui.transparent) and "NONE" or utils.blend(palette.base00, "#000000", 0.2)
        hl.NormalNC = { fg = "dark_grey", bg = bg }
    else
        hl.NormalNC = { link = "Normal" }
    end

    hl.Cursor = { fg = "background", bg = "foreground" }
    hl.lCursor = { link = "Cursor" }
    hl.CursorIM = { link = "Cursor" }
    hl.CursorLine = { bg = { darken = "darkest_grey", amount = 0.6 } }
    hl.CursorColumn = { link = "CursorLine" }
    hl.CursorLineNr = { link = "LineNr" }

    hl.LineNr = { fg = "dark_grey" }
    hl.LineNrAbove = { link = "LineNr" }
    hl.LineNrBelow = { link = "LineNr" }
    hl.SignColumn = { fg = "bright_grey" }

    hl.ColorColumn = { bg = "darkest_grey" }

    hl.WinSeparator = { fg = "dark_grey" }
    hl.VertSplit = { link = "WinSeparator" }

    hl.StatusLine = { fg = "foreground", bg = "dark_grey" }
    hl.StatusLineNC = { link = "StatusLine" }

    hl.WinBar = { fg = "foreground" }
    hl.WinBarNC = { fg = "bright_grey" }

    hl.TabLine = { fg = "bright_grey", bg = "darkest_grey" }
    hl.TabLineSel = { fg = "green", bg = "darkest_grey" }

    hl.Visual = { bg = "darkest_grey" }

    hl.MatchParen = { bg = "dark_grey" }

    hl.Search = { fg = "darkest_grey", bg = "yellow" }
    hl.CurSearch = { link = "Search" }
    hl.IncSearch = { fg = "darkest_grey", bg = "orange" }

    hl.Substitute = { fg = "darkest_grey", bg = "yellow" }

    hl.Pmenu = { bg = (cfg.ui and cfg.ui.transparent) and "NONE" or "background" }
    hl.PmenuSel = { bg = "darkest_grey" }
    hl.PmenuThumb = { bg = "dark_grey" }
    hl.PmenuKind = { link = "Pmenu" }
    hl.PmenuKindSel = { link = "PmenuSel" }
    hl.PmenuExtra = { link = "Pmenu" }
    hl.PmenuExtraSel = { link = "PmenuSel" }
    hl.PmenuSbar = { bg = "dark_grey" }
    hl.PmenuBorder = { link = "FloatBorder" }

    hl.NonText = { fg = "darkest_grey" }
    hl.SpecialKey = { fg = "grey" }
    hl.Whitespace = { link = "NonText" }
    hl.EndOfBuffer = { link = "NonText" }

    hl.Folded = { fg = "grey" }
    hl.FoldColumn = { link = "LineNr" }

    hl.Directory = { fg = "blue" }

    hl.Title = { fg = "bright_blue" }

    hl.Error = { fg = "red" }
    hl.ErrorMsg = { fg = "red" }
    hl.WarningMsg = { fg = "red" }

    hl.ModeMsg = { fg = "green" }
    hl.MoreMsg = { fg = "green" }
    hl.Question = { fg = "blue" }

    hl.Conceal = { fg = "blue" }

    hl.WildMenu = { fg = "red", bg = "yellow" }

    hl.Underlined = { fg = "red" }
    hl.Ignore = { link = "NonText" }

    hl.TermCursor = { link = "Cursor" }
    hl.TermCursorNC = { link = "Cursor" }

    hl.NormalFloat = { link = "Normal" }
    hl.FloatBorder = { fg = "grey" }
    hl.FloatTitle = { link = "Title" }
    hl.FloatFooter = { link = "NonText" }

    hl.QuickFixLine = { bg = "dark_grey" }

    hl.SpellBad = { underline = not cfg.capabilities.undercurl, undercurl = cfg.capabilities.undercurl, sp = "red" }
    hl.SpellCap = { underline = not cfg.capabilities.undercurl, undercurl = cfg.capabilities.undercurl, sp = "orange" }
    hl.SpellLocal =
        { underline = not cfg.capabilities.undercurl, undercurl = cfg.capabilities.undercurl, sp = "orange" }
    hl.SpellRare = { underline = not cfg.capabilities.undercurl, undercurl = cfg.capabilities.undercurl, sp = "orange" }

    hl.DiffAdd = { fg = "background", bg = { darken = "blue", amount = 0.4 } }
    hl.DiffText = { link = "DiffAdd" }
    hl.DiffChange = { link = "Cursorline" }
    hl.DiffDelete = { link = "NonText" }

    hl.MsgArea = { fg = "foreground" }
    hl.MsgSeparator = { fg = "bright_grey" }

    hl.debugPC = { bg = "dark_grey" }
    hl.debugBreakpoint = { fg = "red", bg = "dark_grey" }

    return hl
end

return M
