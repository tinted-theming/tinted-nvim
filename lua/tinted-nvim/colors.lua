-- Palette resolver.
-- Loads a palette from disk, applies user scheme overrides, normalizes the
-- shape so the rest of the plugin sees a consistent palette tree regardless
-- of which scheme system the palette came from.

local M = {}

local SUPPORTED_SYSTEMS = { "base16", "base24", "tinted8" }

local function detect_system(scheme)
    for _, sys in ipairs(SUPPORTED_SYSTEMS) do
        if scheme:match("^" .. sys .. "%-") then
            return sys
        end
    end
    return nil
end

-- Synthesize the tinted8-shaped tree (palette/ui/syntax) from a base16/24
-- palette's legacy base00-baseXX slots. Mirrors the per-key fills in
-- templates/base16.lua.mustache and templates/base24.lua.mustache exactly.
-- Existing tree values (e.g. partial overrides from user-defined schemes) are
-- preserved via deep-merge with "keep" semantics. No-op when there's no
-- legacy slot to synthesize from.
local function synthesize_tree(palette, system)
    if not palette.base00 then
        return palette
    end

    -- Auto-detect base24 by presence of bright slots when no explicit system is given.
    local is_base24 = (system == "base24") or (system == nil and palette.base12 ~= nil)
    local s = palette

    local synthesized = {}
    synthesized.palette = {
        black = { normal = s.base00, bright = s.base01 },
        -- base04 is spec-designated "Light Gray", not a white variant — it lives in gray.bright.
        gray = { dim = s.base02, normal = s.base03, bright = s.base04 },
        -- base06 ("Lighter White") occupies the white.dim slot. Name vs. luminance
        -- is a slot-identifier convention here, not a strict semantic claim.
        white = { dim = s.base06, normal = s.base05, bright = s.base07 },
        red = { normal = s.base08, bright = is_base24 and s.base12 or s.base08 },
        orange = { normal = s.base09, bright = s.base09 },
        yellow = { normal = s.base0A, bright = is_base24 and s.base13 or s.base0A },
        green = { normal = s.base0B, bright = is_base24 and s.base14 or s.base0B },
        cyan = { normal = s.base0C, bright = is_base24 and s.base15 or s.base0C },
        blue = { normal = s.base0D, bright = is_base24 and s.base16 or s.base0D },
        magenta = { normal = s.base0E, bright = is_base24 and s.base17 or s.base0E },
        brown = { normal = s.base0F },
    }

    synthesized.ui = {
        global = {
            background = { normal = s.base00 },
            foreground = { normal = s.base05 },
        },
        cursor = {
            background = { normal = s.base05 },
            foreground = { normal = s.base00 },
        },
        gutter = { foreground = s.base02 },
        border = { normal = s.base03 },
        chrome = {
            background = { normal = s.base02, dark = s.base01 },
            foreground = { normal = s.base05, dark = s.base04 },
        },
        selection = { background = s.base01 },
        highlight = {
            line = { background = s.base01 },
            text = { background = s.base02 },
            search = { background = s.base01, foreground = s.base0A },
        },
        status = {
            error = s.base08,
            warning = s.base09,
            info = s.base0A,
            success = is_base24 and s.base14 or s.base0B,
        },
    }

    synthesized.syntax = {
        comment = s.base03,
        string = {
            default = s.base0B,
            regexp = s.base0B,
            other = s.base0B,
        },
        constant = {
            default = s.base09,
            character = { default = s.base08, escape = s.base0C },
            language = s.base09,
            numeric = { default = s.base09, float = s.base09 },
        },
        entity = {
            name = {
                class = s.base0A,
                type = s.base0A,
                ["function"] = { default = s.base0D, constructor = s.base0D },
                label = s.base0A,
                namespace = s.base08,
                tag = s.base0A,
            },
            other = {
                ["attribute-name"] = s.base0A,
            },
        },
        keyword = {
            default = s.base0E,
            control = { default = s.base0E, import = s.base0D, flow = s.base0A },
            operator = s.base0E,
            declaration = s.base0E,
        },
        storage = { type = s.base0E, modifier = s.base0A },
        variable = {
            default = s.base05,
            parameter = s.base05,
            other = { property = s.base05 },
        },
        punctuation = { separator = s.base0F, section = s.base0F },
        markup = {
            default = s.base05,
            heading = s.base0D,
            raw = s.base09,
            link = s.base09,
            list = s.base0A,
            inserted = s.base0B,
            deleted = s.base08,
        },
        meta = { preprocessor = s.base0A },
    }

    -- "keep" mode: existing values in `palette` win over synthesized ones.
    -- This ensures user-defined schemes with a partial palette/ui/syntax tree
    -- keep their explicit overrides, with only missing leaves filled in.
    return vim.tbl_deep_extend("keep", palette, synthesized)
end

-- For palettes that have the tinted8 tree but lack legacy baseXX slots
-- (e.g. a newly-regenerated tinted8-shape file or a tinted8-native scheme),
-- synthesize the legacy slots from the tree so backwards-compatible consumers
-- (terminal.lua, aliases.lua, user overrides) keep working.
-- Each slot is only filled if missing; nil-safe against partial trees.
local function ensure_legacy_slots(palette, system)
    if not palette.palette then
        return palette
    end

    local p = palette.palette
    local out = vim.tbl_extend("force", {}, palette)
    local function fill(slot, color_name, variant)
        if out[slot] ~= nil then
            return
        end
        local color = p[color_name]
        if color and color[variant] then
            out[slot] = color[variant]
        end
    end

    fill("base00", "black", "normal")
    fill("base01", "black", "bright")
    fill("base02", "gray", "dim")
    fill("base03", "gray", "normal")
    fill("base04", "gray", "bright")
    fill("base05", "white", "normal")
    fill("base06", "white", "dim")
    fill("base07", "white", "bright")
    fill("base08", "red", "normal")
    fill("base09", "orange", "normal")
    fill("base0A", "yellow", "normal")
    fill("base0B", "green", "normal")
    fill("base0C", "cyan", "normal")
    fill("base0D", "blue", "normal")
    fill("base0E", "magenta", "normal")
    fill("base0F", "brown", "normal")

    -- Base24 extended slots: only fill for systems that semantically have brights.
    -- For base16 schemes we deliberately skip these so the cterm map doesn't gain
    -- duplicate hex entries (which would make hex→cterm lookup non-deterministic).
    if system ~= "base16" then
        fill("base10", "black", "normal")
        fill("base11", "black", "bright")
        fill("base12", "red", "bright")
        fill("base13", "yellow", "bright")
        fill("base14", "green", "bright")
        fill("base15", "cyan", "bright")
        fill("base16", "blue", "bright")
        fill("base17", "magenta", "bright")
    end
    return out
end

-- Public: idempotently normalize any palette shape to the canonical dual form
-- (legacy base slots + tinted8 tree). Existing values are never overwritten;
-- only missing keys are filled. Callers that construct palettes outside
-- M.resolve (e.g. tests) can call this to ensure the shape downstream code expects.
---@param palette tinted-nvim.Palette
---@return tinted-nvim.Palette
function M.normalize(palette)
    -- Heuristic system detection from palette shape, used only to decide
    -- whether base10-base17 should be synthesized.
    local detected
    if palette.base17 ~= nil or palette.base12 ~= nil then
        detected = "base24"
    elseif palette.base00 ~= nil then
        detected = "base16"
    else
        detected = "tinted8"
    end
    palette = synthesize_tree(palette, detected)
    palette = ensure_legacy_slots(palette, detected)
    return palette
end

---@param scheme string
---@param config tinted-nvim.Config
---@return tinted-nvim.Palette
function M.resolve(scheme, config)
    local system = detect_system(scheme)
    if not system then
        error(
            string.format(
                "tinted-nvim: invalid scheme-system '%s' (must start with 'base16-', 'base24-', or 'tinted8-')",
                scheme
            )
        )
    end

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

    local palette = base and vim.tbl_extend("force", {}, base) or {}

    if overrides then
        -- Normalize palette to the canonical dual shape (legacy slots + tree)
        -- BEFORE applying overrides. This serves two purposes:
        --   1. Tree blocks the user does NOT touch (e.g. `ui`, `syntax` when
        --      the user only overrides `palette`) carry derived values, so
        --      subsequent validation and synthesis have a complete picture
        --      even when the on-disk file is in old (legacy-only) shape.
        --   2. The snapshot passed to override callbacks (below) is built
        --      from the normalized palette, so callbacks see both shapes.
        palette = synthesize_tree(palette, system)
        palette = ensure_legacy_slots(palette, system)

        -- Deep-copy a snapshot for callback context. Callbacks may capture
        -- a reference to this; we later mutate `palette` (drop one shape so
        -- the final synthesis can re-derive it from the user's updated
        -- values), and we don't want those mutations to retroactively
        -- affect what callbacks captured.
        local snapshot = vim.deepcopy(palette)

        local touched_legacy = false
        local touched_tree = false
        for key, value in pairs(overrides) do
            if type(value) == "function" then
                palette[key] = value(snapshot)
            else
                palette[key] = value
            end
            if type(key) == "string" then
                if key:match("^base%x%x$") then
                    touched_legacy = true
                elseif key == "palette" or key == "ui" or key == "syntax" then
                    touched_tree = true
                end
            end
        end

        -- The on-disk palette file may carry BOTH shapes pre-populated
        -- (post-migration base16/24 templates emit legacy slots AND the tree).
        -- After overrides, the shape the user touched is the source of truth;
        -- drop the OTHER shape so the final normalization re-derives it from
        -- the user's updated values. Without this, "keep"-mode merges would
        -- preserve the file's stale derived shape and override changes would
        -- silently fail to propagate.
        --
        -- If the user touched BOTH shapes, treat both as explicit: leave both
        -- in place and let the final synthesis fill ONLY missing leaves. The
        -- user is responsible for keeping the shapes consistent in this case;
        -- we don't auto-propagate either direction because we can't tell
        -- which side they intended to be canonical for any given leaf.
        if touched_legacy and not touched_tree then
            palette.palette = nil
            palette.ui = nil
            palette.syntax = nil
        elseif touched_tree and not touched_legacy then
            for i = 0, 23 do
                palette[string.format("base%02X", i)] = nil
            end
        end
    end

    if palette.variant ~= "dark" and palette.variant ~= "light" then
        error(string.format("tinted-nvim: scheme '%s' is missing a valid 'variant' field ('dark' or 'light')", scheme))
    end

    -- For base16/24 schemes we accept either input shape:
    --   - legacy-only (baseXX slots) → synthesize tree
    --   - tree-only → synthesize legacy slots
    --   - both → use as-is
    -- Validate that at least one is present.
    if system == "base16" or system == "base24" then
        local has_legacy = palette.base00 ~= nil
        local has_tree = palette.palette ~= nil and palette.ui ~= nil and palette.syntax ~= nil
        if not has_legacy and not has_tree then
            error(string.format("tinted-nvim: scheme '%s' has neither legacy base slots nor tinted8 tree", scheme))
        end
        if has_legacy then
            local max = (system == "base24") and 23 or 15
            for i = 0, max do
                local name = string.format("base%02X", i)
                if palette[name] == nil then
                    error(string.format("tinted-nvim: scheme '%s' is missing required color '%s'", scheme, name))
                end
            end
        end
    end

    if system == "tinted8" then
        if not (palette.palette and palette.ui and palette.syntax) then
            error(string.format("tinted-nvim: tinted8 scheme '%s' is missing required palette/ui/syntax tree", scheme))
        end
    end

    palette = synthesize_tree(palette, system)
    palette = ensure_legacy_slots(palette, system)

    return palette
end

return M
