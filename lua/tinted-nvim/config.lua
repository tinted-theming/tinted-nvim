---@mod tinted-nvim.config Configuration
---@brief [[
---All configuration is done through `setup()`. Defaults are shown below.
---
---Example:
--->lua
---  require("tinted-nvim").setup({
---    default_scheme = "base16-nord",
---    compile = true,
---    ui = { transparent = true },
---  })
---<
---@brief ]]

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

---@mod tinted-nvim.schemes Schemes
---@brief [[
---You can override built-in schemes or define new Base16/Base24 schemes under
---the `schemes` key:
--->lua
---require("tinted-nvim").setup({
---  schemes = {
---    -- Override specific colors of an existing scheme
---    ["base16-catppuccin-mocha"] = {
---      base08 = "#ff0000",
---      base0A = function(palette)
---        return palette.base0B
---      end,
---    },
---    -- Define a completely new scheme
---    ["base16-my-theme"] = {
---      variant = "dark",
---      base00 = "#000000",
---      base01 = "#111111",
---      base02 = "#222222",
---      base03 = "#333333",
---      base04 = "#444444",
---      base05 = "#cccccc",
---      base06 = "#eeeeee",
---      base07 = "#ffffff",
---      base08 = "#ff5555",
---      base09 = "#ffb86c",
---      base0A = "#f1fa8c",
---      base0B = "#50fa7b",
---      base0C = "#8be9fd",
---      base0D = "#bd93f9",
---      base0E = "#ff79c6",
---      base0F = "#ff5555",
---    },
---  },
---})
---<
---
---Custom schemes must start with "base16-" or "base24-". To load a custom
---scheme, use `require("tinted-nvim").load("base16-my-theme")`.
---@brief ]]

---@mod tinted-nvim.selector Selector
---@brief [[
---The selector resolves the scheme name from an external source:
---
---  - `mode = "file"` reads the first line from `selector.path`
---  - `mode = "env"` reads the value from `selector.env`
---  - `mode = "cmd"` runs `selector.cmd` and uses stdout
---
---When `selector.enabled` is false, the plugin uses `default_scheme`.
---
---If `selector.watch` is true and `selector.mode` is "file", the file is
---watched and the scheme is reloaded on changes.
---@brief ]]

---@mod tinted-nvim.highlights Highlights
---@brief [[
---Overrides are returned as a table of highlight specs. Color values can be:
---
---  - Hex colors (`"#rrggbb"`)
---  - `"NONE"`
---  - Color aliases (e.g., `"red"`, `"background"`, `"foreground"`)
---  - Transform tables: `{ darken = <color>, amount = <number> }`
---    or `{ lighten = <color>, amount = <number> }`
---
---Example override:
--->lua
---highlights = {
---  overrides = function(palette)
---    return {
---      Normal = { bg = "#ff0000" },
---      NormalFloat = { link = "Normal" },
---      FloatBorder = { fg = palette.base03 },
---      CursorLine = { bg = "darkest_grey", fg = "foreground" },
---      Search = {
---        bg = { darken = palette.base07, amount = 0.3 },
---        fg = { lighten = "#00ff00", amount = 0.1 },
---      },
---    }
---  end,
---}
---<
---
---If `highlights.use_lazy_specs` is true, tables named `highlights` inside
---lazy.nvim plugin specs are merged into the final highlight table.
---@brief ]]

---@mod tinted-nvim.commands Commands
---@brief [[
---`:TintedNvimCompile [scheme]`
---  Compile a scheme without applying it. If [scheme] is omitted, the selector
---  resolves the scheme name.
---
---`:TintedNvimClearCache`
---  Delete all compiled scheme artifacts from `stdpath("state")/tinted-nvim/`.
---@brief ]]

---@mod tinted-nvim.troubleshooting Troubleshooting
---@brief [[
---Highlights not updating when `compile = true`?
---  Run `:TintedNvimClearCache` and reload the scheme.
---
---Plugin highlights not taking effect?
---  Ensure the integration is enabled in `highlights.integrations` or defined
---  in `highlights.overrides`.
---@brief ]]

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
