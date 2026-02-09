local M = {}

---@param palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, aliases, cfg)
    local a = aliases
    local hl = {}

    hl.LualineNormalA = { fg = a.background, bg = a.grey, bold = true }
    hl.LualineNormalB = { fg = a.foreground, bg = a.dark_grey }
    hl.LualineNormalC = { fg = a.bright_grey, bg = a.darkest_grey }

    hl.LualineInsertA = { fg = a.background, bg = a.blue, bold = true }
    hl.LualineInsertB = { fg = a.foreground, bg = a.dark_grey }
    hl.LualineInsertC = { fg = a.foreground, bg = a.darkest_grey }

    hl.LualineVisualA = { fg = a.background, bg = a.yellow, bold = true }
    hl.LualineVisualB = { fg = a.foreground, bg = a.dark_grey }
    hl.LualineVisualC = { fg = a.background, bg = a.darkest_grey }

    hl.LualineReplaceA = { fg = a.background, bg = a.red, bold = true }
    hl.LualineReplaceB = { fg = a.foreground, bg = a.dark_grey }
    hl.LualineReplaceC = { fg = a.foreground, bg = a.darkest_grey }

    hl.LualineCommandA = { fg = a.background, bg = a.green, bold = true }
    hl.LualineCommandB = { fg = a.foreground, bg = a.dark_grey }
    hl.LualineCommandC = { fg = a.background, bg = a.darkest_grey }

    hl.LualineInactiveA = { fg = a.grey, bg = a.darkest_grey, bold = true }
    hl.LualineInactiveB = { fg = a.grey, bg = a.darkest_grey }
    hl.LualineInactiveC = { fg = a.grey, bg = a.darkest_grey }

    return hl
end

return M
