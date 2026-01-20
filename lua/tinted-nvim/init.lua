local M          = {}

local config     = require("tinted-nvim.config")
local colors     = require("tinted-nvim.colors")
local highlights = require("tinted-nvim.highlights")
local terminal   = require("tinted-nvim.terminal")
local compile    = require("tinted-nvim.compile")
local selector   = require("tinted-nvim.selector")
local aliases    = require("tinted-nvim.aliases")

local state      = {
    scheme          = nil,
    palette         = nil,
    palette_aliases = nil,
}

local function ensure_setup()
    if rawget(config, "options") == nil then
        error("tinted-nvim: setup() must be called first")
    end
end

-- Configure the plugin.
---@param opts? tinted-nvim.Config
function M.setup(opts)
    config.setup(opts)

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

-- Load and apply a scheme.
-- If no scheme is given, resolve via selector.
---@param scheme_name? string
---@param opts? { colorscheme_event?: boolean }
function M.load(scheme_name, opts)
    ensure_setup()
    local cfg = config.options
    local name = scheme_name or selector.resolve(cfg)
    local fire_event = opts == nil or opts.colorscheme_event ~= false

    -- fast path: load compiled artifact if enabled and present
    if cfg.compile and compile.exists(name) then
        if vim.g.colors_name then
            vim.cmd("highlight clear")
        end

        local palette         = compile.load(name)

        vim.o.termguicolors   = true
        vim.g.colors_name     = name

        state.scheme          = name
        state.palette         = palette
        state.palette_aliases = aliases.build(palette)

        if fire_event then
            vim.api.nvim_exec_autocmds("ColorScheme", { pattern = name })
        end

        return
    end

    -- resolve palette (may error, no side effects yet)
    local palette = colors.resolve(name, cfg)

    -- build effects (may error)
    local hl_defs = highlights.build(palette, cfg)
    local term    = terminal.build(palette, cfg)

    -- write compiled artifact if enabled
    if cfg.compile then
        compile.write(name, palette, hl_defs, term)
    end

    -- apply editor state only after everything succeeded
    if vim.g.colors_name then
        vim.cmd("highlight clear")
    end

    vim.o.termguicolors = true
    vim.g.colors_name = name

    -- apply highlights and terminal colors
    highlights.apply(hl_defs, term)
    terminal.apply(term)

    -- commit runtime state
    state.scheme          = name
    state.palette         = palette
    state.palette_aliases = aliases.build(palette)

    if fire_event then
        vim.api.nvim_exec_autocmds("ColorScheme", { pattern = name })
    end
end

-- Compile and write the scheme artifact without applying it.
---@param scheme_name? string
function M.compile(scheme_name)
    ensure_setup()
    local cfg     = config.options
    local name    = scheme_name or selector.resolve(cfg)

    local palette = colors.resolve(name, cfg)
    local hl_defs = highlights.build(palette, cfg)
    local term    = terminal.build(palette, cfg)

    compile.write(name, palette, hl_defs, term)
end

-- Clear all compiled artifacts.
function M.clear_cache()
    compile.clear_all()
end

setmetatable(M, {
    __index = function(_, key)
        ensure_setup()
        if key == "palette" then
            return state.palette
        end
        if key == "palette_aliases" then
            return state.palette_aliases
        end
        if key == "scheme" then
            return state.scheme
        end
    end,
})

return M
