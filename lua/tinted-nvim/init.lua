---@mod tinted-nvim Introduction
---@toc tinted-nvim.contents
---@brief [[
---Tinted-nvim is a Neovim colorscheme plugin that bundles Base16/Base24 schemes
---from the tinted-theming project. It supports built-in and user-defined schemes,
---color aliases, transforms (darken/lighten), highlight overrides, compiled
---highlights for faster startup, and an external scheme selector.
---
---For previewing schemes, use the Tinted Gallery or the Tinty CLI.
---@brief ]]
---@mod tinted-nvim.install Installation
---@brief [[
---Using lazy.nvim:
--->lua
---  {
---    "tinted-theming/tinted-nvim",
---    lazy = false,
---    opts = {
---      -- your config overrides
---    }
---  }
---<
---
---Manual setup:
--->lua
---  require("tinted-nvim").setup({
---    -- your config overrides
---  })
---<
---@brief ]]
---@mod tinted-nvim.usage Usage
---@brief [[
---Load a built-in scheme via `:colorscheme`:
--->
---  :colorscheme base16-catppuccin-frappe
---<
---
---Load any scheme programmatically (built-in or custom):
--->
---  require("tinted-nvim").load("base16-my-custom-scheme")
---<
---
---Calling `load()` without a scheme name resolves it via the selector
---and falls back to `default_scheme` when the selector cannot resolve.
---@brief ]]

local M = {}

local config = require("tinted-nvim.config")
local colors = require("tinted-nvim.colors")
local highlights = require("tinted-nvim.highlights")
local terminal = require("tinted-nvim.terminal")
local compile = require("tinted-nvim.compile")
local selector = require("tinted-nvim.selector")
local aliases = require("tinted-nvim.aliases")
local utils = require("tinted-nvim.utils")

local public_state = {
    scheme = nil,
    palette = nil,
    palette_aliases = nil,
}

---@mod tinted-nvim.api API
---@brief [[
---The main API functions for tinted-nvim.
---@brief ]]

---Configure the plugin. Must be called before using other APIs.
---@param opts? tinted-nvim.Config Configuration options (see |tinted-nvim.config|)
---@usage `require("tinted-nvim").setup({ default_scheme = "base16-nord" })`
function M.setup(opts)
    config.options = vim.tbl_deep_extend("force", {}, config.defaults, opts or {})
    utils.assert_property(config, "options", "tinted-nvim: config is required, something fundamental has gone wrong")

    local cfg = config.options

    -- Start selector watcher if enabled
    if cfg.selector and cfg.selector.enabled and cfg.selector.watch then
        selector.watch(cfg, function(name)
            M.load(name)
        end)
    end

    -- Apply scheme automatically during startup if requested.
    if cfg.apply_scheme_on_startup then
        M.load()
    end

    vim.api.nvim_create_user_command("TintedNvimCompile", function(cmd)
        M.compile(cmd.args ~= "" and cmd.args or nil)
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("TintedNvimClearCache", function()
        M.clear_cache()
    end, {})
end

---Load and apply a scheme.
---If no scheme is given, resolve via selector, falling back to `default_scheme`.
---@param scheme_name? string The scheme name (e.g., "base16-nord")
---@param opts? { colorscheme_event?: boolean } Options. Set to false to suppress the ColorScheme autocmd.
---@usage `require("tinted-nvim").load("base16-dracula")`
function M.load(scheme_name, opts)
    utils.assert_property(config, "options", "tinted-nvim: setup() must be called first")

    local cfg = config.options
    local name = scheme_name or selector.resolve(cfg)
    local fire_event = opts == nil or opts.colorscheme_event ~= false

    -- fast path: load compiled artifact if enabled and present
    if cfg.compile and compile.exists(name) then
        if vim.g.colors_name then
            vim.cmd("highlight clear")
        end

        local palette = compile.load(name)
        if cfg.capabilities.truecolor ~= false then
            vim.o.termguicolors = true
        end
        vim.g.colors_name = name
        public_state.scheme = name
        public_state.palette = palette
        public_state.palette_aliases = aliases.build(palette)

        if fire_event then
            vim.api.nvim_exec_autocmds("ColorScheme", { pattern = name })
        end

        return
    end

    -- resolve palette (may error, no side effects yet)
    local palette = colors.resolve(name, cfg)

    -- build effects (may error)
    local hl_defs = highlights.build(palette, cfg)
    local term = terminal.build(palette, cfg)

    -- write compiled artifact if enabled
    if cfg.compile then
        compile.write(name, palette, hl_defs, term)
    end

    -- apply editor state only after everything succeeded
    if vim.g.colors_name then
        vim.cmd("highlight clear")
    end

    if cfg.capabilities.truecolor ~= false then
        vim.o.termguicolors = true
    end
    vim.g.colors_name = name

    -- apply highlights and terminal colors
    highlights.apply(hl_defs, term)
    terminal.apply(term)

    -- commit runtimepublic_state
    public_state.scheme = name
    public_state.palette = palette
    public_state.palette_aliases = aliases.build(palette)

    if fire_event then
        vim.api.nvim_exec_autocmds("ColorScheme", { pattern = name })
    end
end

---Compile and write the scheme artifact without applying it.
---Use this to pre-compile schemes for faster startup.
---@param scheme_name? string The scheme name. If omitted, resolves via selector.
---@usage `require("tinted-nvim").compile("base16-nord")`
function M.compile(scheme_name)
    utils.assert_property(config, "options", "tinted-nvim: setup() must be called first")

    local cfg = config.options
    local name = scheme_name or selector.resolve(cfg)
    local palette = colors.resolve(name, cfg)
    local hl_defs = highlights.build(palette, cfg)
    local term = terminal.build(palette, cfg)

    compile.write(name, palette, hl_defs, term)
end

---Clear all compiled artifacts from `stdpath("state")/tinted-nvim/`.
---@usage `require("tinted-nvim").clear_cache()`
function M.clear_cache()
    compile.clear_all()
end

---Get the current scheme name.
---@return string|nil scheme The current scheme name, or nil if no scheme is loaded.
---@usage `local name = require("tinted-nvim").get_scheme()`
function M.get_scheme()
    utils.assert_property(config, "options", "tinted-nvim: setup() must be called first")

    return public_state.scheme
end

---Get the current Base16/Base24 palette.
---@return tinted-nvim.Palette|nil palette The current palette table (base00-base0F, optionally base10-base17), or nil.
---@usage `local palette = require("tinted-nvim").get_palette()`
function M.get_palette()
    utils.assert_property(config, "options", "tinted-nvim: setup() must be called first")

    return public_state.palette
end

---Get the current palette with color aliases resolved.
---Aliases include names like "background", "foreground", "red", "green", etc.
---@return table<string, string>|nil aliases A table mapping alias names to hex colors, or nil.
---@usage `local aliases = require("tinted-nvim").get_palette_aliases()`
function M.get_palette_aliases()
    utils.assert_property(config, "options", "tinted-nvim: setup() must be called first")

    return public_state.palette_aliases
end

return M
