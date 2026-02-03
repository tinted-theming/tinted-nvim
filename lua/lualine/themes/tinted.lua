-- We intentionally reference highlight group names instead of defining colors
-- directly in the lualine theme table. Lualine introduces an intermediate
-- abstraction layer for theme definitions, which makes it impossible to specify
-- gui and cterm attributes at the same time.
--
-- By using highlight groups, we bypass this limitation and can define proper
-- gui and cterm values via standard Neovim highlight definitions
local theme = {
    normal = {
        a = 'LualineNormalA',
        b = 'LualineNormalB',
        c = 'LualineNormalC',
    },
    insert = {
        a = 'LualineInsertA',
        b = 'LualineInsertB',
        c = 'LualineInsertC',
    },
    visual = {
        a = 'LualineVisualA',
        b = 'LualineVisualB',
        c = 'LualineVisualC',
    },
    replace = {
        a = 'LualineReplaceA',
        b = 'LualineReplaceB',
        c = 'LualineReplaceC',
    },
    command = {
        a = 'LualineCommandA',
        b = 'LualineCommandB',
        c = 'LualineCommandC',
    },
    inactive = {
        a = 'LualineInactiveA',
        b = 'LualineInactiveB',
        c = 'LualineInactiveC',
    },
}

return theme
