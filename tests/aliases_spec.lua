describe("aliases", function()
    local aliases

    before_each(function()
        package.loaded["tinted-nvim.aliases"] = nil
        aliases = require("tinted-nvim.aliases")
    end)

    local base16_palette = {
        base00 = "#000000",
        base01 = "#111111",
        base02 = "#222222",
        base03 = "#333333",
        base04 = "#444444",
        base05 = "#555555",
        base06 = "#666666",
        base07 = "#777777",
        base08 = "#880000",
        base09 = "#ff9900",
        base0A = "#ffff00",
        base0B = "#00ff00",
        base0C = "#00ffff",
        base0D = "#0000ff",
        base0E = "#ff00ff",
        base0F = "#880000",
    }

    local base24_palette = vim.tbl_extend("force", base16_palette, {
        base10 = "#101010",
        base11 = "#111111",
        base12 = "#ff0000",
        base13 = "#ffff00",
        base14 = "#00ff00",
        base15 = "#00ffff",
        base16 = "#0000ff",
        base17 = "#ff00ff",
    })

    describe("map", function()
        it("maps each alias to a palette tree path string", function()
            assert.is_string(aliases.map.background)
            assert.is_string(aliases.map.foreground)
            assert.is_string(aliases.map.red)
            assert.is_string(aliases.map.bright_red)
        end)

        it("maps background to the canonical black.normal path", function()
            assert.equal("palette.black.normal", aliases.map.background)
        end)

        it("maps foreground to the canonical white.normal path", function()
            assert.equal("palette.white.normal", aliases.map.foreground)
        end)

        it("maps bright colors to the canonical .bright variants", function()
            assert.equal("palette.red.bright", aliases.map.bright_red)
            assert.equal("palette.green.bright", aliases.map.bright_green)
            assert.equal("palette.blue.bright", aliases.map.bright_blue)
        end)
    end)

    describe("cterm", function()
        it("has cterm indices for standard ANSI palette paths", function()
            assert.equal(0, aliases.cterm["palette.black.normal"])
            assert.equal(1, aliases.cterm["palette.red.normal"])
            assert.equal(2, aliases.cterm["palette.green.normal"])
            assert.equal(4, aliases.cterm["palette.blue.normal"])
            assert.equal(7, aliases.cterm["palette.white.normal"])
            assert.equal(15, aliases.cterm["palette.white.bright"])
        end)

        it("has cterm indices for bright color paths", function()
            assert.equal(9, aliases.cterm["palette.red.bright"])
            assert.equal(10, aliases.cterm["palette.green.bright"])
            assert.equal(12, aliases.cterm["palette.blue.bright"])
        end)

        it("does not map paths without an ANSI slot", function()
            -- base10/base11 had no ANSI slot in the old slot-keyed map; their
            -- equivalents simply aren't keys in the tree-keyed map.
            assert.is_nil(aliases.cterm["palette.black.dim"])
        end)
    end)

    describe("resolve", function()
        it("resolves background alias", function()
            local color = aliases.resolve("background", base16_palette)

            assert.equal("#000000", color)
        end)

        it("resolves foreground alias", function()
            local color = aliases.resolve("foreground", base16_palette)

            assert.equal("#555555", color)
        end)

        it("resolves red alias", function()
            local color = aliases.resolve("red", base16_palette)

            assert.equal("#880000", color)
        end)

        it("resolves bright_red with base24 palette", function()
            local color = aliases.resolve("bright_red", base24_palette)

            assert.equal("#ff0000", color)
        end)

        it("resolves bright_red fallback with base16 palette", function()
            local color = aliases.resolve("bright_red", base16_palette)

            assert.equal("#880000", color)
        end)

        it("returns nil for unknown alias", function()
            local color = aliases.resolve("unknown", base16_palette)

            assert.is_nil(color)
        end)
    end)

    describe("build", function()
        it("builds alias table from base16 palette", function()
            local result = aliases.build(base16_palette)

            assert.equal("#000000", result.background)
            assert.equal("#555555", result.foreground)
            assert.equal("#880000", result.red)
            assert.equal("#00ff00", result.green)
            assert.equal("#0000ff", result.blue)
        end)

        it("builds alias table from base24 palette", function()
            local result = aliases.build(base24_palette)

            assert.equal("#ff0000", result.bright_red)
            assert.equal("#00ff00", result.bright_green)
            assert.equal("#0000ff", result.bright_blue)
        end)

        it("uses fallbacks for missing base24 colors", function()
            local result = aliases.build(base16_palette)

            assert.equal("#880000", result.bright_red)
            assert.equal("#00ff00", result.bright_green)
        end)
    end)
end)
