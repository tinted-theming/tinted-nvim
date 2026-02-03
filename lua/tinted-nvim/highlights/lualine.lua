local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    local hl = {}

    hl.LualineNormalA = { fg = 'background', bg = 'grey', bold = true }
    hl.LualineNormalB = { fg = 'foreground', bg = 'dark_grey' }
    hl.LualineNormalC = { fg = 'bright_grey', bg = 'darkest_grey' }

    hl.LualineInsertA = { fg = 'background', bg = 'blue', bold = true }
    hl.LualineInsertB = { fg = 'foreground', bg = 'dark_grey' }
    hl.LualineInsertC = { fg = 'foreground', bg = 'darkest_grey' }

    hl.LualineVisualA = { fg = 'background', bg = 'yellow', bold = true }
    hl.LualineVisualB = { fg = 'foreground', bg = 'dark_grey' }
    hl.LualineVisualC = { fg = 'background', bg = 'darkest_grey' }

    hl.LualineReplaceA = { fg = 'background', bg = 'red', bold = true }
    hl.LualineReplaceB = { fg = 'foreground', bg = 'dark_grey' }
    hl.LualineReplaceC = { fg = 'foreground', bg = 'darkest_grey' }

    hl.LualineCommandA = { fg = 'background', bg = 'green', bold = true }
    hl.LualineCommandB = { fg = 'foreground', bg = 'dark_grey' }
    hl.LualineCommandC = { fg = 'background', bg = 'darkest_grey' }

    hl.LualineInactiveA = { fg = 'grey', bg = 'darkest_grey', bold = true }
    hl.LualineInactiveB = { fg = 'grey', bg = 'darkest_grey' }
    hl.LualineInactiveC = { fg = 'grey', bg = 'darkest_grey' }

    return hl
end

return M
