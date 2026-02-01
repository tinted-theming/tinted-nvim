local M = {}

---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, cfg)
    local styles = cfg.styles or {}
    return {
        Boolean = { fg = "orange" },
        Character = { fg = "red" },
        Comment = vim.tbl_extend("force", { fg = "grey" }, styles.comments or {}),
        Conditional = { fg = "purple" },
        Constant = { fg = "orange" },
        Define = { fg = "purple" },
        Delimiter = { fg = "dark_red" },
        Debug = { fg = "red" },
        Exception = { fg = "red" },
        Float = { fg = "orange" },
        Function = vim.tbl_extend("force", { fg = "blue" }, styles.functions or {}),
        Identifier = { fg = "red" },
        Include = { fg = "blue" },
        Keyword = vim.tbl_extend("force", { fg = "purple" }, styles.keywords or {}),
        Label = { fg = "yellow" },
        Number = { fg = "orange" },
        Operator = { fg = "purple" },
        PreProc = { fg = "yellow" },
        Repeat = { fg = "yellow" },
        Special = { fg = "cyan" },
        SpecialChar = { fg = "dark_red" },
        Statement = { fg = "red" },
        StorageClass = { fg = "yellow" },
        String = { fg = "green" },
        Structure = { fg = "purple" },
        Tag = { fg = "yellow" },
        Todo = { fg = "yellow", bg = "darkest_grey" },
        Type = vim.tbl_extend("force", { fg = "yellow" }, styles.types or {}),
        Typedef = { fg = "yellow" },
    }
end

return M
