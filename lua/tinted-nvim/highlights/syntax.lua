local M = {}

---@param palette tinted-nvim.Palette
---@param _aliases table<string, string>
---@param cfg tinted-nvim.Config
---@return tinted-nvim.Highlights
function M.build(palette, _aliases, cfg)
    local sx = palette.syntax
    local pal = palette.palette
    local ui = palette.ui
    local styles = cfg.styles or {}
    return {
        Boolean = { fg = sx.constant.language },
        Character = { fg = sx.constant.character.default },
        Comment = vim.tbl_extend("force", { fg = sx.comment }, styles.comments or {}),
        Conditional = { fg = sx.keyword.control.default },
        Constant = { fg = sx.constant.default },
        Define = { fg = sx.keyword.declaration },
        Delimiter = { fg = sx.punctuation.separator },
        Debug = { fg = pal.red.normal },
        Exception = { fg = pal.red.normal },
        Float = { fg = sx.constant.numeric.float },
        Function = vim.tbl_extend("force", { fg = sx.entity.name["function"].default }, styles.functions or {}),
        Identifier = { fg = pal.red.normal },
        Include = { fg = sx.keyword.control.import },
        Keyword = vim.tbl_extend("force", { fg = sx.keyword.default }, styles.keywords or {}),
        Label = { fg = sx.entity.name.label },
        Number = { fg = sx.constant.numeric.default },
        Operator = { fg = sx.keyword.operator },
        PreProc = { fg = sx.meta.preprocessor },
        Repeat = { fg = sx.keyword.control.flow },
        Special = { fg = sx.constant.character.escape },
        SpecialChar = { fg = sx.punctuation.section },
        Statement = { fg = pal.red.normal },
        StorageClass = { fg = sx.storage.modifier },
        String = { fg = sx.string.default },
        Structure = { fg = sx.storage.type },
        Tag = { fg = sx.entity.name.tag },
        Todo = { fg = pal.yellow.normal, bg = ui.highlight.line.background },
        Type = vim.tbl_extend("force", { fg = sx.entity.name.type }, styles.types or {}),
        Typedef = { fg = sx.entity.name.type },
    }
end

return M
