local utils = require("tinted-nvim.utils")

local M = {}

---@param palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, aliases, cfg)
    local a = aliases
    local hl = {}

    hl.Normal = { fg = a.foreground, bg = (cfg.ui and cfg.ui.transparent) and "NONE" or a.background }
    if cfg.ui and cfg.ui.dim_inactive then
        local bg = (cfg.ui and cfg.ui.transparent) and "NONE" or utils.blend(palette.base00, "#000000", 0.2)
        hl.NormalNC = { fg = a.dark_grey, bg = bg }
    else
        hl.NormalNC = { link = "Normal" }
    end

    hl.Cursor = { fg = a.background, bg = a.foreground }
    hl.lCursor = { link = "Cursor" }
    hl.CursorIM = { link = "Cursor" }
    hl.CursorLine = { bg = { darken = a.darkest_grey, amount = 0.6 } }
    hl.CursorColumn = { link = "CursorLine" }
    hl.CursorLineNr = { link = "LineNr" }

    hl.LineNr = { fg = a.dark_grey }
    hl.LineNrAbove = { link = "LineNr" }
    hl.LineNrBelow = { link = "LineNr" }
    hl.SignColumn = { fg = a.bright_grey }

    hl.ColorColumn = { bg = a.darkest_grey }

    hl.WinSeparator = { fg = a.dark_grey }
    hl.VertSplit = { link = "WinSeparator" }

    hl.StatusLine = { fg = a.foreground, bg = a.dark_grey }
    hl.StatusLineNC = { link = "StatusLine" }

    hl.WinBar = { fg = a.foreground }
    hl.WinBarNC = { fg = a.bright_grey }

    hl.TabLine = { fg = a.bright_grey, bg = a.darkest_grey }
    hl.TabLineSel = { fg = a.green, bg = a.darkest_grey }

    hl.Visual = { bg = a.darkest_grey }

    hl.MatchParen = { bg = a.dark_grey }

    hl.Search = { fg = a.darkest_grey, bg = a.yellow }
    hl.CurSearch = { link = "Search" }
    hl.IncSearch = { fg = a.darkest_grey, bg = a.orange }

    hl.Substitute = { fg = a.darkest_grey, bg = a.yellow }

    hl.Pmenu = { bg = (cfg.ui and cfg.ui.transparent) and "NONE" or a.background }
    hl.PmenuSel = { bg = a.darkest_grey }
    hl.PmenuThumb = { bg = a.dark_grey }
    hl.PmenuKind = { link = "Pmenu" }
    hl.PmenuKindSel = { link = "PmenuSel" }
    hl.PmenuExtra = { link = "Pmenu" }
    hl.PmenuExtraSel = { link = "PmenuSel" }
    hl.PmenuSbar = { bg = a.dark_grey }
    hl.PmenuBorder = { link = "FloatBorder" }

    hl.NonText = { fg = a.darkest_grey }
    hl.SpecialKey = { fg = a.grey }
    hl.Whitespace = { link = "NonText" }
    hl.EndOfBuffer = { link = "NonText" }

    hl.Folded = { fg = a.grey }
    hl.FoldColumn = { link = "LineNr" }

    hl.Directory = { fg = a.blue }

    hl.Title = { fg = a.bright_blue }

    hl.Error = { fg = a.red }
    hl.ErrorMsg = { fg = a.red }
    hl.WarningMsg = { fg = a.red }

    hl.ModeMsg = { fg = a.green }
    hl.MoreMsg = { fg = a.green }
    hl.Question = { fg = a.blue }

    hl.Conceal = { fg = a.blue }

    hl.WildMenu = { fg = a.red, bg = a.yellow }

    hl.Underlined = { fg = a.red }
    hl.Ignore = { link = "NonText" }

    hl.TermCursor = { link = "Cursor" }
    hl.TermCursorNC = { link = "Cursor" }

    hl.NormalFloat = { link = "Normal" }
    hl.FloatBorder = { fg = a.grey }
    hl.FloatTitle = { link = "Title" }
    hl.FloatFooter = { link = "NonText" }

    hl.QuickFixLine = { bg = a.dark_grey }

    hl.SpellBad = { underline = not cfg.capabilities.undercurl, undercurl = cfg.capabilities.undercurl, sp = a.red }
    hl.SpellCap = { underline = not cfg.capabilities.undercurl, undercurl = cfg.capabilities.undercurl, sp = a.orange }
    hl.SpellLocal =
        { underline = not cfg.capabilities.undercurl, undercurl = cfg.capabilities.undercurl, sp = a.orange }
    hl.SpellRare = { underline = not cfg.capabilities.undercurl, undercurl = cfg.capabilities.undercurl, sp = a.orange }

    hl.DiffAdd = { fg = a.background, bg = { darken = a.blue, amount = 0.4 } }
    hl.DiffText = { link = "DiffAdd" }
    hl.DiffChange = { link = "Cursorline" }
    hl.DiffDelete = { link = "NonText" }

    hl.MsgArea = { fg = a.foreground }
    hl.MsgSeparator = { fg = a.bright_grey }

    hl.debugPC = { bg = a.dark_grey }
    hl.debugBreakpoint = { fg = a.red, bg = a.dark_grey }

    return hl
end

return M
