local M = {}

local color_aliases = {
    background = {"base00"},
    black = {"base01"},
    bright_black     = {"base02"},
    grey = {"base03"},
    bright_grey = {"base04"},
    foreground = {"base05"},
    white = {"base06"},
    bright_white = {"base07"},
    red = {"base08"},
    bright_red = {"base12", "base08"},
    orange = {"base09"},
    yellow = {"base0A"},
    bright_yellow = {"base13", "base0A"},
    green = {"base14", "base0B"},
    bright_green = {"base0B"},
    cyan = {"base0C"},
    bright_cyan = {"base15", "base0C"},
    blue = {"base0D"},
    bright_blue = {"base16", "base0D"},
    purple = {"base0E"},
    bright_purple = {"base17", "base0E"},
    dark_red = {"base0F"},
    brown = {"base0F"},
}

---@param colors ColorTable
---@return ColorTable
local function color_table(colors)
    return setmetatable(colors, {
        __index = function(t, k)
            local indices = color_aliases[k]
            if indices == nil then
                return nil
            end
            for _, v in ipairs(indices) do
                local color = t[v]
                if color ~= nil then
                    return color
                end
            end
            return nil
        end,
    })
end

---@type ColorTable
---@diagnostic disable-next-line: missing-fields
M.colors = color_table({})

local hex_re = vim.regex('#\\x\\x\\x\\x\\x\\x')

local HEX_DIGITS = {
    ['0'] = 0,
    ['1'] = 1,
    ['2'] = 2,
    ['3'] = 3,
    ['4'] = 4,
    ['5'] = 5,
    ['6'] = 6,
    ['7'] = 7,
    ['8'] = 8,
    ['9'] = 9,
    ['a'] = 10,
    ['b'] = 11,
    ['c'] = 12,
    ['d'] = 13,
    ['e'] = 14,
    ['f'] = 15,
    ['A'] = 10,
    ['B'] = 11,
    ['C'] = 12,
    ['D'] = 13,
    ['E'] = 14,
    ['F'] = 15,
}

local function hex_to_rgb(hex)
    return HEX_DIGITS[string.sub(hex, 1, 1)] * 16 + HEX_DIGITS[string.sub(hex, 2, 2)],
        HEX_DIGITS[string.sub(hex, 3, 3)] * 16 + HEX_DIGITS[string.sub(hex, 4, 4)],
        HEX_DIGITS[string.sub(hex, 5, 5)] * 16 + HEX_DIGITS[string.sub(hex, 6, 6)]
end

local function rgb_to_hex(r, g, b)
    return bit.tohex(bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b), 6)
end

local function darken(hex, pct)
    pct = 1 - pct
    local r, g, b = hex_to_rgb(string.sub(hex, 2))
    r = math.floor(r * pct)
    g = math.floor(g * pct)
    b = math.floor(b * pct)
    return string.format("#%s", rgb_to_hex(r, g, b))
end

local function get_tinty_theme()
    if vim.fn.executable('tinty') == 1 then
        local theme_name = vim.fn.system({ "tinty", "current" })

        return vim.trim(theme_name or "")
    end

    return ""
end

M.is_suitable_color_table = function(colors)
    local keys = {"00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "0A", "0B", "0C", "0D", "0E", "0F"}
    for _, k in ipairs(keys) do
        if colors["base" .. k] == nil then
            return false
        end
    end
    return true
end

-- This function takes in a base16 palette key value and returns the base24
-- bright variant palette key, otherwise if a base24 bright variant doesn't
-- exist, it falls back to the key provided initially
local function get_bright(key)
    local normal_to_bright_key_color_map = {
        base01 = "base02", -- Black = Bright Black
        base02 = "base02", -- Bright Black = Bright Black
        base03 = "base03", -- Grey = Grey
        base04 = "base04", -- Light Grey = Light Grey
        base05 = "base05", -- Foreground = Foreground
        base06 = "base07", -- White = Bright White
        base07 = "base07", -- Bright White = Bright White
        base08 = "base12", -- Red = Bright Red
        base09 = "base09", -- Orange = Orange
        base0A = "base13", -- Yellow = Bright Yellow
        base0B = "base14", -- Green = Bright Green
        base0C = "base15", -- Cyan = Bright Cyan
        base0D = "base16", -- Blue = Bright Blue
        base0E = "base17", -- Purple = Bright Purple
        base0F = "base0F", -- Brown = Brown
    }
    local bright_color_key = normal_to_bright_key_color_map[key]

    return M.colors[bright_color_key] or M.colors[key]
end

-- This is a bit of syntactic sugar for creating highlight groups.
--
-- local colorscheme = require('colorscheme')
-- local hi = colorscheme.highlight
-- hi.Comment = { guifg='#ffffff', guibg='#000000', gui='italic', guisp=nil }
-- hi.LspDiagnosticsDefaultError = 'DiagnosticError' -- Link to another group
--
-- This is equivalent to the following vimscript
--
-- hi Comment guifg=#ffffff guibg=#000000 gui=italic
-- hi! link LspDiagnosticsDefaultError DiagnosticError
M.highlight = setmetatable({}, {
    __newindex = function(_, hlgroup, args)
        if ('string' == type(args)) then
            vim.api.nvim_set_hl(0, hlgroup, { link = args })
            return
        end

        local guifg, guibg, gui, guisp = args.guifg or nil, args.guibg or nil, args.gui or nil, args.guisp or nil
        local ctermfg, ctermbg = args.ctermfg or nil, args.ctermbg or nil
        local val = {}
        if guifg then val.fg = guifg end
        if guibg then val.bg = guibg end
        if ctermfg then val.ctermfg = ctermfg end
        if ctermbg then val.ctermbg = ctermbg end
        if guisp then val.sp = guisp end
        if gui then
            for x in string.gmatch(gui, '([^,]+)') do
                if x ~= "none" then
                    val[x] = true
                end
            end
        end
        vim.api.nvim_set_hl(0, hlgroup, val)
    end
})

local function trigger_autocmd()
  vim.cmd([[doautocmd User TintedColorsPost]])
end

---@param colors ColorTable
---@param colorscheme_name string
---@param clear_highlights boolean
---@param highlights HighlightsConfig
M.set_highlights = function(colors, colorscheme_name, clear_highlights, highlights)

    clear_highlights = clear_highlights or false

    if clear_highlights == true then
        vim.cmd([[hi clear]])
    end

    vim.o.termguicolors = true
    vim.g.tinted_colorspace = 256

    if type(colorscheme_name) == "string" and #colorscheme_name > 0 then

        if clear_highlights == false then
            -- There is no case where we set the colorscheme name and where we don't highlights cleared.
            vim.cmd([[hi clear]])
        end

        vim.g.tinted_current_colorscheme = colorscheme_name
        vim.g.colors_name = colorscheme_name
    end

    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end


    M.colors                              = color_table(colors)

    local hi                              = M.highlight

    -- Vim editor colors
    hi.Normal                             = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
    hi.Bold                               = { guifg = nil, guibg = nil, gui = 'bold', guisp = nil, ctermfg = nil, ctermbg = nil }
    hi.Debug                              = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.Directory                          = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.Error                              = { guifg = M.colors.base08, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.ErrorMsg                           = { guifg = M.colors.base08, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.Exception                          = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.FoldColumn                         = { guifg = M.colors.base0C, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = M.colors.cterm00 }
    hi.Folded                             = { guifg = M.colors.base03, guibg = M.colors.base01, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = M.colors.cterm01 }
    hi.IncSearch                          = { guifg = M.colors.base01, guibg = M.colors.base09, gui = 'none', guisp = nil, ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm09 }
    hi.Italic                             = { guifg = nil, guibg = nil, gui = 'italic', guisp = nil, ctermfg = nil, ctermbg = nil }
    hi.Macro                              = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.MatchParen                         = { guifg = nil, guibg = M.colors.base03, gui = nil, guisp = nil, ctermfg = nil, ctermbg = M.colors.cterm03 }
    hi.ModeMsg                            = { guifg = M.colors.base0B, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.MoreMsg                            = { guifg = M.colors.base0B, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.Question                           = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.Search                             = { guifg = M.colors.base01, guibg = M.colors.base0A, gui = nil, guisp = nil, ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm0A }
    hi.Substitute                         = { guifg = M.colors.base01, guibg = M.colors.base0A, gui = 'none', guisp = nil, ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm0A }
    hi.SpecialKey                         = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.TooLong                            = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.Underlined                         = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.Visual                             = { guifg = nil, guibg = M.colors.base02, gui = nil, guisp = nil, ctermfg = nil, ctermbg = M.colors.cterm02 }
    hi.VisualNOS                          = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.WarningMsg                         = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.WildMenu                           = { guifg = M.colors.base08, guibg = M.colors.base0A, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm0A }
    hi.Title                              = { guifg = get_bright("base0D"), guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.Conceal                            = { guifg = M.colors.base0D, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = M.colors.cterm00 }
    hi.Cursor                             = { guifg = M.colors.base00, guibg = M.colors.base05, gui = nil, guisp = nil, ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm05 }
    hi.NonText                            = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.LineNr                             = { guifg = M.colors.base04, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm04, ctermbg = M.colors.cterm00 }
    hi.SignColumn                         = { guifg = M.colors.base04, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm04, ctermbg = M.colors.cterm00 }
    hi.StatusLine                         = { guifg = M.colors.base05, guibg = M.colors.base02, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm02 }
    hi.StatusLineNC                       = { guifg = M.colors.base04, guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = M.colors.cterm04, ctermbg = M.colors.cterm01 }
    hi.WinBar                             = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
    hi.WinBarNC                           = { guifg = M.colors.base04, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm04, ctermbg = nil }
    hi.VertSplit                          = { guifg = M.colors.base05, guibg = M.colors.base00, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
    hi.ColorColumn                        = { guifg = nil, guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = nil, ctermbg = M.colors.cterm01 }
    hi.CursorColumn                       = { guifg = nil, guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = nil, ctermbg = M.colors.cterm01 }
    hi.CursorLine                         = { guifg = nil, guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = nil, ctermbg = M.colors.cterm01 }
    hi.CursorLineNr                       = { guifg = get_bright("base04"), guibg = M.colors.base01, gui = nil, guisp = nil, ctermfg = M.colors.cterm04, ctermbg = M.colors.cterm01 }
    hi.QuickFixLine                       = { guifg = nil, guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = nil, ctermbg = M.colors.cterm01 }
    hi.PMenu                              = { guifg = M.colors.base05, guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm01 }
    hi.PMenuSel                           = { guifg = M.colors.base01, guibg = M.colors.base05, gui = nil, guisp = nil, ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm05 }
    hi.TabLine                            = { guifg = M.colors.base03, guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = M.colors.cterm03, ctermbg = M.colors.cterm01 }
    hi.TabLineFill                        = { guifg = M.colors.base03, guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = M.colors.cterm03, ctermbg = M.colors.cterm01 }
    hi.TabLineSel                         = { guifg = M.colors.base0B, guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm01 }

    -- Standard syntax highlighting
    hi.Boolean                            = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.Character                          = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.Comment                            = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.Conditional                        = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.Constant                           = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.Define                             = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.Delimiter                          = { guifg = M.colors.base0F, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
    hi.Float                              = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.Function                           = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.Identifier                         = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.Include                            = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.Keyword                            = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.Label                              = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.Number                             = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.Operator                           = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.PreProc                            = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.Repeat                             = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.Special                            = { guifg = M.colors.base0C, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
    hi.SpecialChar                        = { guifg = M.colors.base0F, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
    hi.Statement                          = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.StorageClass                       = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.String                             = { guifg = M.colors.base0B, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.Structure                          = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.Tag                                = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.Todo                               = { guifg = M.colors.base0A, guibg = M.colors.base01, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = M.colors.cterm01 }
    hi.Type                               = { guifg = M.colors.base0A, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.Typedef                            = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }

    -- Diff highlighting
    hi.DiffAdd                            = { guifg = M.colors.base0B, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm00 }
    hi.DiffChange                         = { guifg = M.colors.base0E, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = M.colors.cterm00 }
    hi.DiffDelete                         = { guifg = M.colors.base08, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.DiffText                           = { guifg = M.colors.base0D, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = M.colors.cterm00 }
    hi.DiffAdded                          = { guifg = M.colors.base0B, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm00 }
    hi.DiffFile                           = { guifg = M.colors.base08, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.DiffNewFile                        = { guifg = M.colors.base0B, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm00 }
    hi.DiffLine                           = { guifg = M.colors.base0D, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = M.colors.cterm00 }
    hi.DiffRemoved                        = { guifg = M.colors.base08, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }

    -- Git highlighting
    hi.gitcommitOverflow                  = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.gitcommitSummary                   = { guifg = M.colors.base0B, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.gitcommitComment                   = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.gitcommitUntracked                 = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.gitcommitDiscarded                 = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.gitcommitSelected                  = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.gitcommitHeader                    = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.gitcommitSelectedType              = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.gitcommitUnmergedType              = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.gitcommitDiscardedType             = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.gitcommitBranch                    = { guifg = M.colors.base09, guibg = nil, gui = 'bold', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.gitcommitUntrackedFile             = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.gitcommitUnmergedFile              = { guifg = M.colors.base08, guibg = nil, gui = 'bold', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.gitcommitDiscardedFile             = { guifg = M.colors.base08, guibg = nil, gui = 'bold', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.gitcommitSelectedFile              = { guifg = M.colors.base0B, guibg = nil, gui = 'bold', guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }

    -- GitGutter highlighting
    hi.GitGutterAdd                       = { guifg = M.colors.base0B, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm00 }
    hi.GitGutterChange                    = { guifg = M.colors.base0E, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = M.colors.cterm00 }
    hi.GitGutterDelete                    = { guifg = M.colors.base08, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.GitGutterChangeDelete              = { guifg = M.colors.base09, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = M.colors.cterm00 }

    -- Spelling highlighting
    hi.SpellBad                           = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base08, ctermfg = nil, ctermbg = nil }
    hi.SpellLocal                         = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base0C, ctermfg = nil, ctermbg = nil }
    hi.SpellCap                           = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base0D, ctermfg = nil, ctermbg = nil }
    hi.SpellRare                          = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base0E, ctermfg = nil, ctermbg = nil }

    hi.DiagnosticError                    = { guifg = get_bright("base08"), guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.DiagnosticWarn                     = { guifg = get_bright("base0E"), guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.DiagnosticInfo                     = { guifg = get_bright("base0D"), guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.DiagnosticHint                     = { guifg = get_bright("base0C"), guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
    hi.DiagnosticUnderlineError           = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = get_bright("base08"), ctermfg = nil, ctermbg = nil }
    hi.DiagnosticUnderlineWarning         = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = get_bright("base0E"), ctermfg = nil, ctermbg = nil }
    hi.DiagnosticUnderlineWarn            = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base0E, ctermfg = nil, ctermbg = nil }
    hi.DiagnosticUnderlineInformation     = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base0F, ctermfg = nil, ctermbg = nil }
    hi.DiagnosticUnderlineHint            = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base0C, ctermfg = nil, ctermbg = nil }

    hi.LspReferenceText                   = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
    hi.LspReferenceRead                   = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
    hi.LspReferenceWrite                  = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
    hi.LspDiagnosticsDefaultError         = 'DiagnosticError'
    hi.LspDiagnosticsDefaultWarning       = 'DiagnosticWarn'
    hi.LspDiagnosticsDefaultInformation   = 'DiagnosticInfo'
    hi.LspDiagnosticsDefaultHint          = 'DiagnosticHint'
    hi.LspDiagnosticsUnderlineError       = 'DiagnosticUnderlineError'
    hi.LspDiagnosticsUnderlineWarning     = 'DiagnosticUnderlineWarning'
    hi.LspDiagnosticsUnderlineInformation = 'DiagnosticUnderlineInformation'
    hi.LspDiagnosticsUnderlineHint        = 'DiagnosticUnderlineHint'

    hi.TSAnnotation                       = { guifg = M.colors.base0F, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
    hi.TSAttribute                        = { guifg = M.colors.base0A, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.TSBoolean                          = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.TSCharacter                        = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.TSComment                          = { guifg = M.colors.base03, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.TSConstructor                      = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.TSConditional                      = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.TSConstant                         = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.TSConstBuiltin                     = { guifg = M.colors.base09, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.TSConstMacro                       = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.TSError                            = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.TSException                        = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.TSField                            = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
    hi.TSFloat                            = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.TSFunction                         = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.TSFuncBuiltin                      = { guifg = M.colors.base0D, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.TSFuncMacro                        = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.TSInclude                          = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.TSKeyword                          = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.TSKeywordFunction                  = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.TSKeywordOperator                  = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.TSLabel                            = { guifg = M.colors.base0A, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.TSMethod                           = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.TSNamespace                        = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.TSNone                             = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
    hi.TSNumber                           = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.TSOperator                         = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
    hi.TSParameter                        = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
    hi.TSParameterReference               = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
    hi.TSProperty                         = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
    hi.TSPunctDelimiter                   = { guifg = M.colors.base0F, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
    hi.TSPunctBracket                     = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
    hi.TSPunctSpecial                     = { guifg = M.colors.base0F, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
    hi.TSRepeat                           = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.TSString                           = { guifg = M.colors.base0B, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.TSStringRegex                      = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
    hi.TSStringEscape                     = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
    hi.TSSymbol                           = { guifg = M.colors.base0B, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.TSTag                              = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.TSTagDelimiter                     = { guifg = M.colors.base0F, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
    hi.TSText                             = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
    hi.TSStrong                           = { guifg = nil, guibg = nil, gui = 'bold', guisp = nil, ctermfg = nil, ctermbg = nil }
    hi.TSEmphasis                         = { guifg = M.colors.base09, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.TSUnderline                        = { guifg = M.colors.base00, guibg = nil, gui = 'underline', guisp = nil, ctermfg = M.colors.cterm00, ctermbg = nil }
    hi.TSStrike                           = { guifg = M.colors.base00, guibg = nil, gui = 'strikethrough', guisp = nil, ctermfg = M.colors.cterm00, ctermbg = nil }
    hi.TSTitle                            = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.TSLiteral                          = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.TSURI                              = { guifg = M.colors.base09, guibg = nil, gui = 'underline', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.TSType                             = { guifg = M.colors.base0A, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.TSTypeBuiltin                      = { guifg = M.colors.base0A, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.TSVariable                         = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.TSVariableBuiltin                  = { guifg = M.colors.base08, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }

    hi.TSDefinition                       = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
    hi.TSDefinitionUsage                  = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
    hi.TSCurrentScope                     = { guifg = nil, guibg = nil, gui = 'bold', guisp = nil, ctermfg = nil, ctermbg = nil }

    hi.LspInlayHint                       = { guifg = M.colors.base03, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }

    if vim.fn.has('nvim-0.8.0') then
        hi['@comment']                  = 'TSComment'
        hi['@error']                    = 'TSError'
        hi['@none']                     = 'TSNone'
        hi['@preproc']                  = 'PreProc'
        hi['@define']                   = 'Define'
        hi['@operator']                 = 'TSOperator'
        hi['@punctuation.delimiter']    = 'TSPunctDelimiter'
        hi['@punctuation.bracket']      = 'TSPunctBracket'
        hi['@punctuation.special']      = 'TSPunctSpecial'
        hi['@string']                   = 'TSString'
        hi['@string.regex']             = 'TSStringRegex'
        hi['@string.escape']            = 'TSStringEscape'
        hi['@string.special']           = 'SpecialChar'
        hi['@character']                = 'TSCharacter'
        hi['@character.special']        = 'SpecialChar'
        hi['@boolean']                  = 'TSBoolean'
        hi['@number']                   = 'TSNumber'
        hi['@float']                    = 'TSFloat'
        hi['@function']                 = 'TSFunction'
        hi['@function.call']            = 'TSFunction'
        hi['@function.builtin']         = 'TSFuncBuiltin'
        hi['@function.macro']           = 'TSFuncMacro'
        hi['@method']                   = 'TSMethod'
        hi['@method.call']              = 'TSMethod'
        hi['@constructor']              = 'TSConstructor'
        hi['@parameter']                = 'TSParameter'
        hi['@keyword']                  = 'TSKeyword'
        hi['@keyword.function']         = 'TSKeywordFunction'
        hi['@keyword.operator']         = 'TSKeywordOperator'
        hi['@keyword.return']           = 'TSKeyword'
        hi['@conditional']              = 'TSConditional'
        hi['@repeat']                   = 'TSRepeat'
        hi['@debug']                    = 'Debug'
        hi['@label']                    = 'TSLabel'
        hi['@include']                  = 'TSInclude'
        hi['@exception']                = 'TSException'
        hi['@type']                     = 'TSType'
        hi['@type.builtin']             = 'TSTypeBuiltin'
        hi['@type.qualifier']           = 'TSKeyword'
        hi['@type.definition']          = 'TSType'
        hi['@storageclass']             = 'StorageClass'
        hi['@attribute']                = 'TSAttribute'
        hi['@field']                    = 'TSField'
        hi['@property']                 = 'TSProperty'
        hi['@variable']                 = 'TSVariable'
        hi['@variable.builtin']         = 'TSVariableBuiltin'
        hi['@constant']                 = 'TSConstant'
        hi['@constant.builtin']         = 'TSConstant'
        hi['@constant.macro']           = 'TSConstant'
        hi['@namespace']                = 'TSNamespace'
        hi['@symbol']                   = 'TSSymbol'
        hi['@text']                     = 'TSText'
        hi['@text.diff.add']            = 'DiffAdd'
        hi['@text.diff.delete']         = 'DiffDelete'
        hi['@text.strong']              = 'TSStrong'
        hi['@text.emphasis']            = 'TSEmphasis'
        hi['@text.underline']           = 'TSUnderline'
        hi['@text.strike']              = 'TSStrike'
        hi['@text.title']               = 'TSTitle'
        hi['@text.literal']             = 'TSLiteral'
        hi['@text.uri']                 = 'TSUri'
        hi['@text.math']                = 'Number'
        hi['@text.environment']         = 'Macro'
        hi['@text.environment.name']    = 'Type'
        hi['@text.reference']           = 'TSParameterReference'
        hi['@text.todo']                = 'Todo'
        hi['@text.note']                = 'Tag'
        hi['@text.warning']             = 'DiagnosticWarn'
        hi['@text.danger']              = 'DiagnosticError'
        hi['@tag']                      = 'TSTag'
        hi['@tag.attribute']            = 'TSAttribute'
        hi['@tag.delimiter']            = 'TSTagDelimiter'

        hi['@function.method']          = '@method'
        hi['@function.method.call']     = '@method.call'
        hi['@comment.error']            = '@text.danger'
        hi['@comment.warning']          = '@text.warning'
        hi['@comment.hint']             = 'DiagnosticHint'
        hi['@comment.info']             = 'DiagnosticInfo'
        hi['@comment.todo']             = '@text.todo'
        hi['@diff.plus']                = '@text.diff.add'
        hi['@diff.minus']               = '@text.diff.delete'
        hi['@diff.delta']               = 'DiffChange'
        hi['@string.special.url']       = '@text.uri'
        hi['@keyword.directive']        = '@preproc'
        hi['@keyword.directive.define'] = '@define'
        hi['@keyword.storage']          = '@storageclass'
        hi['@keyword.conditional']      = '@conditional'
        hi['@keyword.debug']            = '@debug'
        hi['@keyword.exception']        = '@exception'
        hi['@keyword.import']           = '@include'
        hi['@keyword.repeat']           = '@repeat'
        hi['@variable.parameter']       = '@parameter'
        hi['@variable.member']          = '@field'
        hi['@module']                   = '@namespace'
        hi['@number.float']             = '@float'
        hi['@string.special.symbol']    = '@symbol'
        hi['@string.regexp']            = '@string.regex'
        hi['@markup.strong']            = '@text.strong'
        hi['@markup.italic']            = 'Italic'
        hi['@markup.link']              = '@text.link'
        hi['@markup.strikethrough']     = '@text.strikethrough'
        hi['@markup.heading']           = '@text.title'
        hi['@markup.raw']               = '@text.literal'
        hi['@markup.link']              = '@text.reference'
        hi['@markup.link.url']          = '@text.uri'
        hi['@markup.link.label']        = '@string.special'
        hi['@markup.list']              = '@punctuation.special'
    end

    if highlights.ts_rainbow then
        hi.rainbowcol1 = { guifg = get_bright("base06"), ctermfg = M.colors.cterm06 }
        hi.rainbowcol2 = { guifg = get_bright("base09"), ctermfg = M.colors.cterm09  }
        hi.rainbowcol3 = { guifg = get_bright("base0A"), ctermfg = M.colors.cterm0A }
        hi.rainbowcol4 = { guifg = get_bright("base07"), ctermfg = M.colors.cterm07  }
        hi.rainbowcol5 = { guifg = get_bright("base0C"), ctermfg = M.colors.cterm0C  }
        hi.rainbowcol6 = { guifg = get_bright("base0D"), ctermfg = M.colors.cterm0D  }
        hi.rainbowcol7 = { guifg = get_bright("base0E"), ctermfg = M.colors.cterm0E  }
    end

    hi.NvimInternalError = { guifg = M.colors.base00, guibg = M.colors.base08, gui = 'none', guisp = nil, ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm08 }

    hi.NormalFloat       = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
    hi.FloatBorder       = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
    hi.NormalNC          = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
    hi.TermCursor        = { guifg = M.colors.base00, guibg = M.colors.base05, gui = 'none', guisp = nil, ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm05 }
    hi.TermCursorNC      = { guifg = M.colors.base00, guibg = M.colors.base05, gui = nil, guisp = nil, ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm05 }

    hi.User1             = { guifg = get_bright("base08"), guibg = M.colors.base02, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm02 }
    hi.User2             = { guifg = get_bright("base09"), guibg = M.colors.base02, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = M.colors.cterm02 }
    hi.User3             = { guifg = get_bright("base0B"), guibg = M.colors.base02, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm02 }
    hi.User4             = { guifg = get_bright("base0C"), guibg = M.colors.base02, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = M.colors.cterm02 }
    hi.User5             = { guifg = get_bright("base0D"), guibg = M.colors.base02, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm02 }
    hi.User6             = { guifg = get_bright("base0E"), guibg = M.colors.base01, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm01 }
    hi.User7             = { guifg = M.colors.base05, guibg = M.colors.base02, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm02 }
    hi.User8             = { guifg = M.colors.base00, guibg = M.colors.base02, gui = 'none', guisp = nil, ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm02 }
    hi.User9             = { guifg = M.colors.base00, guibg = M.colors.base02, gui = 'none', guisp = nil, ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm02 }

    hi.TreesitterContext = { guifg = nil, guibg = M.colors.base01, gui = 'italic', guisp = nil, ctermfg = nil, ctermbg = M.colors.cterm01 }

    if highlights.telescope then
        if not highlights.telescope_borders and hex_re:match_str(M.colors.base00) and hex_re:match_str(M.colors.base01) and
            hex_re:match_str(M.colors.base02) then
            local darkerbg           = darken(M.colors.base00, 0.1)
            local darkercursorline   = darken(M.colors.base01, 0.1)
            local darkerstatusline   = darken(M.colors.base02, 0.1)
            hi.TelescopeBorder       = { guifg = darkerbg, guibg = darkerbg, gui = nil, guisp = nil }
            hi.TelescopePromptBorder = { guifg = darkerstatusline, guibg = darkerstatusline, gui = nil, guisp = nil }
            hi.TelescopePromptNormal = { guifg = M.colors.base05, guibg = darkerstatusline, gui = nil, guisp = nil }
            hi.TelescopePromptPrefix = { guifg = M.colors.base08, guibg = darkerstatusline, gui = nil, guisp = nil }
            hi.TelescopeNormal       = { guifg = nil, guibg = darkerbg, gui = nil, guisp = nil }
            hi.TelescopePreviewTitle = { guifg = darkercursorline, guibg = get_bright("base0B"), gui = nil, guisp = nil }
            hi.TelescopePromptTitle  = { guifg = darkercursorline, guibg = M.colors.base08, gui = nil, guisp = nil }
            hi.TelescopeResultsTitle = { guifg = darkerbg, guibg = darkerbg, gui = nil, guisp = nil }
            hi.TelescopeSelection    = { guifg = nil, guibg = darkerstatusline, gui = nil, guisp = nil }
            hi.TelescopePreviewLine  = { guifg = nil, guibg = M.colors.base01, gui = 'none', guisp = nil }
        else
            hi.TelescopeBorder       = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
            hi.TelescopePromptBorder = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
            hi.TelescopePromptNormal = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
            hi.TelescopePromptPrefix = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
            hi.TelescopeNormal       = { guifg = nil, guibg = M.colors.base00, gui = nil, guisp = nil }
            hi.TelescopePreviewTitle = { guifg = M.colors.base01, guibg = get_bright("base0B"), gui = nil, guisp = nil }
            hi.TelescopePromptTitle  = { guifg = M.colors.base01, guibg = M.colors.base08, gui = nil, guisp = nil }
            hi.TelescopeResultsTitle = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
            hi.TelescopeSelection    = { guifg = nil, guibg = M.colors.base01, gui = nil, guisp = nil }
            hi.TelescopePreviewLine  = { guifg = nil, guibg = M.colors.base01, gui = 'none', guisp = nil }
        end
    end

    if highlights.notify then
        hi.NotifyERRORBorder = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.NotifyWARNBorder  = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
        hi.NotifyINFOBorder  = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
        hi.NotifyDEBUGBorder = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
        hi.NotifyTRACEBorder = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
        hi.NotifyERRORIcon   = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.NotifyWARNIcon    = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
        hi.NotifyINFOIcon    = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
        hi.NotifyDEBUGIcon   = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
        hi.NotifyTRACEIcon   = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
        hi.NotifyERRORTitle  = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.NotifyWARNTitle   = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
        hi.NotifyINFOTitle   = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
        hi.NotifyDEBUGTitle  = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
        hi.NotifyTRACETitle  = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
        hi.NotifyERRORBody   = 'Normal'
        hi.NotifyWARNBody    = 'Normal'
        hi.NotifyINFOBody    = 'Normal'
        hi.NotifyDEBUGBody   = 'Normal'
        hi.NotifyTRACEBody   = 'Normal'
    end

    if highlights.indentblankline then
        hi.IndentBlanklineChar        = { guifg = M.colors.base02, gui = 'nocombine', ctermfg = M.colors.cterm02 }
        hi.IndentBlanklineContextChar = { guifg = M.colors.base04, gui = 'nocombine', ctermfg = M.colors.cterm04  }
        hi.IblIndent                  = { guifg = M.colors.base02, gui = 'nocombine', ctermfg = M.colors.cterm02  }
        hi.IblWhitespace              = 'Whitespace'
        hi.IblScope                   = { guifg = M.colors.base04, gui = 'nocombine', ctermfg = M.colors.cterm04  }
    end

    if highlights.cmp then
        hi.CmpDocumentationBorder   = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
        hi.CmpDocumentation         = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
        hi.CmpItemAbbr              = { guifg = M.colors.base05, guibg = M.colors.base01, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm01 }
        hi.CmpItemAbbrDeprecated    = { guifg = M.colors.base03, guibg = nil, gui = 'strikethrough', guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
        hi.CmpItemAbbrMatch         = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemAbbrMatchFuzzy    = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemKindDefault       = { guifg = M.colors.base05, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
        hi.CmpItemMenu              = { guifg = M.colors.base04, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm04, ctermbg = nil }
        hi.CmpItemKindKeyword       = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
        hi.CmpItemKindVariable      = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.CmpItemKindConstant      = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
        hi.CmpItemKindReference     = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.CmpItemKindValue         = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
        hi.CmpItemKindFunction      = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemKindMethod        = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemKindConstructor   = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemKindClass         = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindInterface     = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindStruct        = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindEvent         = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindEnum          = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindUnit          = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindModule        = { guifg = M.colors.base05, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
        hi.CmpItemKindProperty      = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.CmpItemKindField         = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.CmpItemKindTypeParameter = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindEnumMember    = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindOperator      = { guifg = M.colors.base05, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
        hi.CmpItemKindSnippet       = { guifg = M.colors.base04, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm04, ctermbg = nil }
    end

    if highlights.illuminate then
        hi.IlluminatedWordText  = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
        hi.IlluminatedWordRead  = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
        hi.IlluminatedWordWrite = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
    end

    if highlights.lsp_semantic then
        hi['@class'] = 'TSType'
        hi['@struct'] = 'TSType'
        hi['@enum'] = 'TSType'
        hi['@enumMember'] = 'Constant'
        hi['@event'] = 'Identifier'
        hi['@interface'] = 'Structure'
        hi['@modifier'] = 'Identifier'
        hi['@regexp'] = 'TSStringRegex'
        hi['@typeParameter'] = 'Type'
        hi['@decorator'] = 'Identifier'

        hi['@lsp.type.namespace'] = '@namespace'
        hi['@lsp.type.type'] = '@type'
        hi['@lsp.type.class'] = '@type'
        hi['@lsp.type.enum'] = '@type'
        hi['@lsp.type.interface'] = '@type'
        hi['@lsp.type.struct'] = '@type'
        hi['@lsp.type.parameter'] = '@parameter'
        hi['@lsp.type.variable'] = '@variable'
        hi['@lsp.type.property'] = '@property'
        hi['@lsp.type.enumMember'] = '@constant'
        hi['@lsp.type.function'] = '@function'
        hi['@lsp.type.method'] = '@method'
        hi['@lsp.type.macro'] = '@function.macro'
        hi['@lsp.type.decorator'] = '@function'
    end

    if highlights.mini_completion then
        hi.MiniCompletionActiveParameter = 'CursorLine'
    end

    if highlights.dapui then
        hi.DapUINormal = 'Normal'
        hi.DapUINormal    = "Normal"
        hi.DapUIVariable  = "Normal"
        hi.DapUIScope     = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIType      = { guifg = M.colors.base0E, ctermfg = M.colors.cterm0E }
        hi.DapUIValue     = "Normal"
        hi.DapUIModifiedValue = { gui = "bold", guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIDecoration = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIThread    = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
        hi.DapUIStoppedThread = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIFrameName = "Normal"
        hi.DapUISource    = { guifg = M.colors.base0E, ctermfg = M.colors.cterm0E }
        hi.DapUILineNumber = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIFloatNormal = "NormalFloat"
        hi.DapUIFloatBorder = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIWatchesEmpty = { guifg = M.colors.base08, ctermfg = M.colors.cterm08 }
        hi.DapUIWatchesValue = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
        hi.DapUIWatchesError = { guifg = M.colors.base08, ctermfg = M.colors.cterm08 }
        hi.DapUIBreakpointsPath = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIBreakpointsInfo = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
        hi.DapUIBreakpointsCurrentLine = { gui = "bold", guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
        hi.DapUIBreakpointsLine = "DapUILineNumber"
        hi.DapUIBreakpointsDisabledLine = { guifg = M.colors.base02, ctermfg = M.colors.cterm02 }
        hi.DapUICurrentFrameName = "DapUIBreakpointsCurrentLine"
        hi.DapUIStepOver  = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIStepInto  = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIStepBack  = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIStepOut   = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIStop      = { guifg = M.colors.base08, ctermfg = M.colors.cterm08 }
        hi.DapUIPlayPause = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
        hi.DapUIRestart   = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
        hi.DapUIUnavailable = { guifg = M.colors.base02, ctermfg = M.colors.cterm02 }
        hi.DapUIWinSelect = { gui = "bold", guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIEndofBuffer = "EndOfBuffer"
        hi.DapUINormalNC  = "Normal"
        hi.DapUIPlayPauseNC = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
        hi.DapUIRestartNC = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
        hi.DapUIStopNC    = { guifg = M.colors.base08, ctermfg = M.colors.cterm08 }
        hi.DapUIUnavailableNC = { guifg = M.colors.base02, ctermfg = M.colors.cterm02 }
        hi.DapUIStepOverNC = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIStepIntoNC = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIStepBackNC = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
        hi.DapUIStepOutNC = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
    end


    vim.g.terminal_color_0  = M.colors.base00
    vim.g.terminal_color_1  = M.colors.base08
    vim.g.terminal_color_2  = M.colors.base0B
    vim.g.terminal_color_3  = M.colors.base0A
    vim.g.terminal_color_4  = M.colors.base0D
    vim.g.terminal_color_5  = M.colors.base0E
    vim.g.terminal_color_6  = M.colors.base0C
    vim.g.terminal_color_7  = M.colors.base06
    vim.g.terminal_color_8  = M.colors.base02
    vim.g.terminal_color_9  = get_bright("base08")
    vim.g.terminal_color_10 = get_bright("base0B")
    vim.g.terminal_color_11 = get_bright("base0A")
    vim.g.terminal_color_12 = get_bright("base0D")
    vim.g.terminal_color_13 = get_bright("base0E")
    vim.g.terminal_color_14 = get_bright("base0C")
    vim.g.terminal_color_15 = M.colors.base07

    vim.g.tinted_gui00      = M.colors.base00
    vim.g.tinted_gui01      = M.colors.base01
    vim.g.tinted_gui02      = M.colors.base02
    vim.g.tinted_gui03      = M.colors.base03
    vim.g.tinted_gui04      = M.colors.base04
    vim.g.tinted_gui05      = M.colors.base05
    vim.g.tinted_gui06      = M.colors.base06
    vim.g.tinted_gui07      = M.colors.base07
    vim.g.tinted_gui08      = M.colors.base08
    vim.g.tinted_gui09      = M.colors.base09
    vim.g.tinted_gui0A      = M.colors.base0A
    vim.g.tinted_gui0B      = M.colors.base0B
    vim.g.tinted_gui0C      = M.colors.base0C
    vim.g.tinted_gui0D      = M.colors.base0D
    vim.g.tinted_gui0E      = M.colors.base0E
    vim.g.tinted_gui0F      = M.colors.base0F
    vim.g.tinted_gui10      = M.colors.base10
    vim.g.tinted_gui11      = M.colors.base11
    vim.g.tinted_gui12      = M.colors.base12
    vim.g.tinted_gui13      = M.colors.base13
    vim.g.tinted_gui14      = M.colors.base14
    vim.g.tinted_gui15      = M.colors.base15
    vim.g.tinted_gui16      = M.colors.base16
    vim.g.tinted_gui17      = M.colors.base17

    trigger_autocmd()
end

return M
