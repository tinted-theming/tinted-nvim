local M = {}

---@type tinted-nvim.Config
M.defaults = {
    default_scheme = "base16-ayu-dark",

    apply_scheme_on_startup = true,

    compile = false,

    ---@type tinted-nvim.Config.Capabilities
    capabilities = {
        undercurl = false,
        terminal_colors = true,
    },

    ---@type tinted-nvim.Config.Ui
    ui = {
        transparent  = false,
        dim_inactive = false,
    },

    ---@type tinted-nvim.Config.Styles
    styles = {
        comments  = { italic = true },
        keywords  = {},
        functions = {},
        variables = {},
        types     = {},
    },

    ---@type tinted-nvim.Config.Highlights
    highlights = {
        integrations = {
            telescope = true,
            notify    = true,
            cmp       = true,
            blink     = true,
            dapui     = true,
        },
        use_lazy_specs = true,

        overrides = function(palette)
            return {}
        end,
    },

    ---@type table<string, tinted-nvim.SchemeSpec>
    schemes = {},

    ---@type tinted-nvim.Config.Selector
    selector = {
        enabled = false,
        mode    = "file",
        watch   = true,
        path    = "~/.local/share/tinted-theming/tinty/current_scheme",
        env     = "TINTED_THEME",
        cmd     = "tinty current",
    },
}

---@type tinted-nvim.Config?
M.options = nil

---@param opts? tinted-nvim.Config
function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

setmetatable(M, {
    __index = function(_, k)
        if k == "options" then
            return M.options or M.defaults
        end
    end,
})

return M
