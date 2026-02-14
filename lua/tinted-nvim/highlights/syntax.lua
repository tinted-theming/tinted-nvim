local M = {}

---@param _palette tinted-nvim.Palette
---@param aliases table<string, string>
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(_palette, aliases, cfg)
    local a = aliases
    local styles = cfg.styles or {}
    return {
        Boolean = { fg = a.orange },
        Character = { fg = a.red },
        Comment = vim.tbl_extend("force", { fg = a.grey }, styles.comments or {}),
        Conditional = { fg = a.purple },
        Constant = { fg = a.orange },
        Define = { fg = a.purple },
        Delimiter = { fg = a.dark_red },
        Debug = { fg = a.red },
        Exception = { fg = a.red },
        Float = { fg = a.orange },
        Function = vim.tbl_extend("force", { fg = a.blue }, styles.functions or {}),
        Identifier = { fg = a.red },
        Include = { fg = a.blue },
        Keyword = vim.tbl_extend("force", { fg = a.purple }, styles.keywords or {}),
        Label = { fg = a.yellow },
        Number = { fg = a.orange },
        Operator = { fg = a.purple },
        PreProc = { fg = a.yellow },
        Repeat = { fg = a.yellow },
        Special = { fg = a.cyan },
        SpecialChar = { fg = a.dark_red },
        Statement = { fg = a.red },
        StorageClass = { fg = a.yellow },
        String = { fg = a.green },
        Structure = { fg = a.purple },
        Tag = { fg = a.yellow },
        Todo = { fg = a.yellow, bg = a.darkest_grey },
        Type = vim.tbl_extend("force", { fg = a.yellow }, styles.types or {}),
        Typedef = { fg = a.yellow },
    }
end

return M
