-- Build the complete highlight table.
-- This module:
--   - collects highlights from all domains
--   - applies user overrides
--   - resolves color aliases
--   - returns a flat table ready for nvim_set_hl()

local M = {}

-- Domain builders (always on)
local core = require("tinted-nvim.highlights.core")
local syntax = require("tinted-nvim.highlights.syntax")
local treesitter = require("tinted-nvim.highlights.treesitter")
local lsp = require("tinted-nvim.highlights.lsp")
local diagnostics = require("tinted-nvim.highlights.diagnostics")
local aliases = require("tinted-nvim.aliases")
local utils = require("tinted-nvim.utils")

-- Integrations (opt in)
local integrations = {
    telescope = "tinted-nvim.highlights.telescope",
    notify = "tinted-nvim.highlights.notify",
    cmp = "tinted-nvim.highlights.cmp",
    blink = "tinted-nvim.highlights.blink",
    dapui = "tinted-nvim.highlights.dapui",
}

-- Resolve a single color value.
local function resolve_color(value, palette)
    if type(value) == "table" then
        local amount = value.amount or 0
        if type(amount) ~= "number" then
            error("tinted-nvim: color transform amount must be a number")
        end

        local target = value.darken or value.lighten
        if not target then
            error("tinted-nvim: color transform requires darken or lighten")
        end

        local base = resolve_color(target, palette)
        if base == "NONE" then
            return "NONE", nil
        end
        if type(base) ~= "string" or not base:match("^#%x%x%x%x%x%x$") then
            error("tinted-nvim: color transform requires a hex color")
        end
        if value.darken then
            local background = palette.base00
            if type(background) ~= "string" or not background:match("^#%x%x%x%x%x%x$") then
                error("tinted-nvim: background color could not be resolved")
            end
            return utils.darken(base, amount, background), nil
        end
        local foreground = palette.base05
        if type(foreground) ~= "string" or not foreground:match("^#%x%x%x%x%x%x$") then
            error("tinted-nvim: foreground color could not be resolved")
        end
        return utils.lighten(base, amount, foreground), nil
    end

    if type(value) ~= "string" then
        return value, nil
    end

    local lower = value:lower()
    if lower == "none" then
        return "NONE", nil
    end

    -- hex color
    if value:match("^#%x%x%x%x%x%x$") then
        return value, nil
    end

    -- alias
    local color, base_key = aliases.resolve(value, palette)
    if color then
        return color, base_key
    end

    error("tinted-nvim: color '" .. value .. "' is not a hex or alias")
end

-- Resolve aliases in a highlight spec.
local function resolve_spec(spec, palette)
    if spec.link then
        return spec
    end

    local out = {}
    for k, v in pairs(spec) do
        if k == "fg" or k == "bg" then
            local color, base_key = resolve_color(v, palette)
            out[k] = color
            -- Only add cterm colors when we can map a baseXX alias to ANSI.
            if base_key and aliases.cterm[base_key] then
                local cterm_key = k == "fg" and "ctermfg" or "ctermbg"
                if out[cterm_key] == nil then
                    out[cterm_key] = aliases.cterm[base_key]
                end
            end
        elseif k == "sp" then
            local color = resolve_color(v, palette)
            out[k] = color
        else
            out[k] = v
        end
    end
    return out
end

-- Build full highlight table.
---@param palette tinted-nvim.Palette
---@param cfg tinted-nvim.Config
---@return table<string, tinted-nvim.Highlight>
function M.build(palette, cfg)
    local result = {}

    -- helper to merge domain output
    local function merge(tbl)
        for group, spec in pairs(tbl or {}) do
            result[group] = spec
        end
    end

    -- core domains
    merge(core.build(palette, cfg))
    merge(syntax.build(palette, cfg))
    merge(treesitter.build(palette, cfg))
    merge(lsp.build(palette, cfg))
    merge(diagnostics.build(palette, cfg))

    -- integrations
    local enabled = cfg.highlights and cfg.highlights.integrations or {}
    for name, module_path in pairs(integrations) do
        if enabled[name] then
            local mod = require(module_path)
            merge(mod.build(palette, cfg))
        end
    end

    -- lazy.nvim plugin spec highlights (optional)
    if cfg.highlights and cfg.highlights.use_lazy_specs then
        local ok, lazy_config = pcall(require, "lazy.core.config")
        if ok and lazy_config and lazy_config.plugins then
            for _, plugin in pairs(lazy_config.plugins) do
                if plugin.highlights then
                    merge(plugin.highlights)
                end
            end
        end
    end

    -- user overrides (last)
    if cfg.highlights and type(cfg.highlights.overrides) == "function" then
        merge(cfg.highlights.overrides(palette))
    end

    -- resolve aliases
    local resolved = {}
    for group, spec in pairs(result) do
        resolved[group] = resolve_spec(spec, palette)
    end

    return resolved
end

-- Apply highlights.
---@param highlights table<string, tinted-nvim.Highlight>
function M.apply(highlights)
    for group, spec in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, spec)
    end
end

return M
