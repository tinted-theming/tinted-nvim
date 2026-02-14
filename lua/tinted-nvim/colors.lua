-- Palette resolver.
-- Loads a Base16/Base24 palette from disk, applies user scheme overrides,
-- and returns a fully resolved palette with only concrete hex colors.

local M = {}

---@param scheme string
---@param config tinted-nvim.Config
---@return tinted-nvim.Palette
function M.resolve(scheme, config)
    if not scheme:match("^base16%-") and not scheme:match("^base24%-") then
        error(string.format("tinted-nvim: invalid scheme-system '%s' (must start with 'base16-' or 'base24-')", scheme))
    end

    -- load base palette from palettes/<scheme>.lua
    local base
    local ok, result = pcall(require, "tinted-nvim.palettes." .. scheme)
    if ok and type(result) == "table" then
        base = result
    end

    local overrides = config and config.schemes and config.schemes[scheme]

    if not base and not overrides then
        error(
            string.format(
                "tinted-nvim: scheme '%s' is not defined (no builtin palette or user definition found)",
                scheme
            )
        )
    end

    -- shallow copy to avoid mutating the cached source palette
    local palette = base and vim.tbl_extend("force", {}, base) or {}

    -- apply user overrides for this scheme
    if overrides then
        for key, value in pairs(overrides) do
            if type(value) == "function" then
                palette[key] = value(palette)
            else
                palette[key] = value
            end
        end
    end

    if palette.variant ~= "dark" and palette.variant ~= "light" then
        error(string.format("tinted-nvim: scheme '%s' is missing a valid 'variant' field ('dark' or 'light')", scheme))
    end

    local is_base24 = scheme:match("^base24%-") ~= nil
    local max = is_base24 and 23 or 15

    for i = 0, max do
        local name = string.format("base%02X", i)
        if palette[name] == nil then
            error(string.format("tinted-nvim: scheme '%s' is missing required color '%s'", scheme, name))
        end
    end

    return palette
end

return M
