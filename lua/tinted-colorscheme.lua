-- Some useful links for making your own colorscheme:
--
-- https://github.com/tinted-theming/home
-- https://colourco.de/
-- https://color.adobe.com/create/color-wheel
-- http://vrl.cs.brown.edu/color
--

--- @class SupportsConfig
--- @field tinty boolean Integrate with Tinty CLI
--- @field live_reload boolean Automatically reload with a new theme is picked via Tinty
--- @field tinted_shell boolean Load the colorscheme set by tinted-theming/tinted-shell.
---
--- @class HighlightsConfig
--- @field telescope boolean Set highlights for Telescope
--- @field telescope_borders boolean Set highlights for Telescope borders
--- @field indentblankline boolean Set highlights for indentblankline
--- @field notify boolean Set highlights for notify
--- @field ts_rainbow boolean  Set highlights for ts_rainbow
--- @field cmp boolean  Set highlights for cmp
--- @field illuminate boolean Set highlights for illuminate
--- @field lsp_semantic boolean Set LSP semantic highlights
--- @field mini_completion boolean Set highlights for mini.completion
--- @field dapui boolean Set highlights for dapui
---
--- @class Config
---
--- @field supports SupportsConfig
--- @field highlights HighlightsConfig
---
--- @type Config
local default_config = {
    supports = {
        tinty = true,
        live_reload = false,
        tinted_shell = false,
    },
    highlights = {
        telescope = true,
        telescope_borders = false,
        indentblankline = true,
        notify = true,
        ts_rainbow = true,
        cmp = true,
        illuminate = true,
        lsp_semantic = true,
        mini_completion = true,
        dapui = true,
    }
}

--- @class ColorTable
---
--- @field base00 string
--- @field base01 string
--- @field base02 string
--- @field base03 string
--- @field base04 string
--- @field base05 string
--- @field base06 string
--- @field base07 string
--- @field base08 string
--- @field base09 string
--- @field base0A string
--- @field base0B string
--- @field base0C string
--- @field base0D string
--- @field base0E string
--- @field base0F string

--- @class Module
local M = {}

local highlighter = require("tinted-highlighter")

M.highlight = highlighter.highlight

local function trigger_autocmd()
  vim.cmd([[doautocmd User TintedColorsPost]])
end

M.set_colors = function (colors, name)
   M.colors = colors
   highlighter.set_highlights(colors, name, true, M.config.highlights);
    trigger_autocmd()
end

local function get_tinty_theme()
    if vim.fn.executable('tinty') == 1 then
        local theme_name = vim.fn.system({ "tinty", "current" })

        return vim.trim(theme_name or "")
    end
    return ""
end

---@return ColorTable
---@return string
local function detect_colors_from_tinty()
    local current_tinty_theme = vim.trim(get_tinty_theme())

    -- If the Tinty theme is not null
    if current_tinty_theme ~= nil and current_tinty_theme ~= '' then
        -- Set to Tinty theme if new theme name is different to already set
        if current_tinty_theme ~= vim.g.current_colorscheme_name then
            -- Safely get colorscheme object from Tinty theme name
            local ok, colorscheme = pcall(function()
                return M.colorschemes[current_tinty_theme], current_tinty_theme
            end)

            if ok then
                return colorscheme, current_tinty_theme
            end

            vim.notify(
                string.format("Failed to load Tinty colorscheme '%s'", current_tinty_theme),
                vim.log.levels.WARN
            )
        end
    else
        vim.notify(
            string.format("Failed to load Tinty colorscheme '%s'", current_tinty_theme),
            vim.log.levels.WARN
        )
    end

    return {}, ""
end

function M.with_config(config)
    if M.config == nil then
        M.config = default_config
    end

    M.config.supports = vim.tbl_extend("force", default_config.supports, config.supports or M.config.supports or {})
    M.config.highlights = vim.tbl_extend("force", default_config.supports, config.highlights or M.config.highlights or {})

    -- Live-reload only supports reading current theme from Tinty.
    if M.config.supports.live_reload == true and M.config.supports.tinty == false then
        vim.notify(
            "Live-reload feature only works with Tinty integration.",
            vim.log.levels.WARN
        )
    end

    if M.config.supports.tinty == true and M.config.supports.live_reload then
        require("tinted-live-reload").setup_live_reload(function()
            local colors, name = detect_colors_from_tinty()
            if #name > 0 then
                M.set_colors(colors, name)
            end
        end)
    end
end

--- @return ColorTable, string
local function attempt_load_colors_from_string(colors)
    if not type(colors) == "string" then
        return {}, ""
    end

    if #colors == 0 then
        return {}, ""
    end

    local ok, colorscheme = pcall(function()
        -- TODO: Do somewhere else
        vim.g.tinted_current_colorscheme = colors
        return M.colorschemes[colors]
    end)

    if ok then
        return colorscheme, colors
    end

    return {}, ""
end



---@return ColorTable, string
local function attempt_load_colors_from_tinty()
    if not M.config.supports.tinty == true then
        return {}, ""
    end
    return detect_colors_from_tinty()
end

---@return ColorTable, string
local function attempt_load_colors_from_tinted_shell()
    if not M.config.supports.tinted_shell == true then
        return {}, ""
    end

    local tmux_env = vim.env.TMUX
    local theme_env = vim.env.BASE16_THEME

    -- Only trust BASE16_THEME if not inside a tmux session due to how TMUX handles env vars.
    if tmux_env ~= nil or (type(tmux_env) == "string" and #tmux_env == 0) then
        return {}, ""
    end

    if theme_env ~= nil or (type(theme_env) == "string" and #theme_env == 0) then
        return {}, ""
    end

    local ok, colorscheme = pcall(function()
        return M.colorschemes[theme_env]
    end)

    if ok then
        return colorscheme, theme_env
    end

    return {}, ""
end




--- When a color-table is provided as the `colors` param, it is applied as the colorscheme.
---
--- When a string is specified, it is interpreted as the name of a built-in colorscheme and it will be applied.
--- Builtin colorschemes can be found in the M.colorschemes table.
--
-- The default Vim highlight groups (including User[1-9]), highlight groups
-- pertaining to Neovim's builtin LSP, and highlight groups pertaining to
-- Treesitter will be defined.
--
-- It's worth noting that many colorschemes will specify language specific
-- highlight groups like rubyConstant or pythonInclude. However, I don't do
-- that here since these should instead be linked to an existing highlight
-- group.
--
--- @param colors (ColorTable|string|nil)
--- @param config Config
function M.setup(colors, config)
    M.with_config(config or {})

    local current_colorscheme_name = vim.g.tinted_current_colorscheme;

    ---@type ColorTable
    ---@diagnostic disable-next-line: missing-fields
    local colors_to_use = {}
    local scheme_name = ""

    -- If the caller passed in a non-empty table for `colors` parameter, those must be the color-table that we apply.
    -- We set the `colors_to_use` to the provided table and all auto-theming logic during setup must short-circuit
    -- based on its presence.
    -- Thus, the order in which we try to determine what color-table to use must be done in order of precedence.
    if type(colors) == 'table' and highlighter.is_suitable_color_table(colors) then
        colors_to_use = colors
    end

    -- First, let's check if setup is called with a `colors` string value. We'll interpret that as a colorscheme.
    if not highlighter.is_suitable_color_table(colors_to_use) then
        colors_to_use, scheme_name = attempt_load_colors_from_string(colors)
    end

    -- Second, let's check if Tinty is supported and potentially load the colorscheme from there.
    if not highlighter.is_suitable_color_table(colors_to_use) then
        colors_to_use, scheme_name = attempt_load_colors_from_tinty()
    end

    -- Third, let's check if tinted-shell is supported and potentially load the colorscheme from there.
    if not highlighter.is_suitable_color_table(colors_to_use) then
        colors_to_use, scheme_name = attempt_load_colors_from_tinted_shell()
    end


    -- Lastly, default to tinted-nvim-default
    if not highlighter.is_suitable_color_table(colors_to_use) then
        scheme_name = "tinted-nvim-default"
        colors_to_use = M.colorschemes[scheme_name]
        vim.notify(
            string.format(
                "Unable to find suitable color-table from `colors` param '%s'. Using default '%s'.",
                vim.inspect(colors),
                scheme_name
            ),
            vim.log.levels.WARN
        )
    end


    M.set_colors(colors_to_use, scheme_name);
end

function M.available_colorschemes()
    return vim.tbl_keys(M.colorschemes)
end

M.colorschemes = {}
setmetatable(M.colorschemes, {
    __index = function(t, key)
        t[key] = require(string.format('colors.%s', key))
        return t[key]
    end,
})

-- Fallback colorscheme
M.colorschemes['tinted-nvim-default'] = {
    base00 = "#0F1419",
    base01 = "#131721",
    base02 = "#272D38",
    base03 = "#3E4B59",
    base04 = "#BFBDB6",
    base05 = "#E6E1CF",
    base06 = "#E6E1CF",
    base07 = "#F3F4F5",
    base08 = "#F07178",
    base09 = "#FF8F40",
    base0A = "#FFB454",
    base0B = "#B8CC52",
    base0C = "#95E6CB",
    base0D = "#59C2FF",
    base0E = "#D2A6FF",
    base0F = "#E6B673",
}

return M
