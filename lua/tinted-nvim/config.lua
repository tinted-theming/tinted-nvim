local M = {}

---@class tinted-nvim.Config
---@field default_scheme string Fallback scheme when selector cannot resolve. Default: "base16-ayu-dark"
---@field apply_scheme_on_startup boolean Apply scheme automatically during startup. Default: true
---@field compile boolean Compile highlights for faster startup. Default: false
---@field capabilities tinted-nvim.Config.Capabilities Terminal capability options
---@field ui tinted-nvim.Config.Ui UI appearance options
---@field styles tinted-nvim.Config.Styles Text style overrides for syntax groups
---@field highlights tinted-nvim.Config.Highlights Highlight configuration
---@field schemes table<string, tinted-nvim.SchemeSpec> Custom scheme definitions or overrides
---@field selector tinted-nvim.Config.Selector External scheme selector configuration

---@class tinted-nvim.Config.Capabilities
---@field undercurl boolean Use undercurl (falls back to underline if false). Default: false
---@field terminal_colors boolean Set terminal colors (g:terminal_color_0..17). Default: true

---@class tinted-nvim.Config.Ui
---@field transparent boolean Leave Normal background unset. Default: false
---@field dim_inactive boolean Dim inactive windows. Default: false

---@class tinted-nvim.Config.Styles
---@field comments table Style for comments. Default: { italic = true }
---@field keywords table Style for keywords. Default: {}
---@field functions table Style for functions. Default: {}
---@field variables table Style for variables. Default: {}
---@field types table Style for types. Default: {}

---@class tinted-nvim.Config.Highlights
---@field integrations table<string, boolean> Enable/disable plugin integrations (telescope, notify, cmp, blink, dapui)
---@field use_lazy_specs boolean Merge highlights from lazy.nvim plugin specs. Default: true
---@field overrides fun(palette: tinted-nvim.Palette): table Function returning highlight overrides

---@class tinted-nvim.Config.Selector
---@field enabled boolean Enable external selector. Default: false
---@field mode string Selector mode: "file", "env", or "cmd". Default: "file"
---@field watch boolean Watch file for changes (file mode only). Default: true
---@field path string Path to scheme file. Default: "~/.local/share/tinted-theming/tinty/current_scheme"
---@field env string Environment variable name. Default: "TINTED_THEME"
---@field cmd string Command to run. Default: "tinty current"
---@type tinted-nvim.Config
M.defaults = {
    default_scheme = "base16-ayu-dark",

    apply_scheme_on_startup = true,

    compile = false,

    capabilities = {
        undercurl = false,
        terminal_colors = true,
    },

    ui = {
        transparent = false,
        dim_inactive = false,
    },

    styles = {
        comments = { italic = true },
        keywords = {},
        functions = {},
        variables = {},
        types = {},
    },

    highlights = {
        integrations = {
            telescope = true,
            notify = true,
            cmp = true,
            blink = true,
            dapui = true,
        },
        use_lazy_specs = true,

        overrides = function(_palette)
            return {}
        end,
    },

    schemes = {},

    selector = {
        enabled = false,
        mode = "file",
        watch = true,
        path = "~/.local/share/tinted-theming/tinty/current_scheme",
        env = "TINTED_THEME",
        cmd = "tinty current",
    },
}

---@type tinted-nvim.Config?
M.options = nil

return M
