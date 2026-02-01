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
        it("has expected alias mappings", function()
            assert.is_table(aliases.map.background)
            assert.is_table(aliases.map.foreground)
            assert.is_table(aliases.map.red)
            assert.is_table(aliases.map.green)
            assert.is_table(aliases.map.blue)
        end)

        it("maps background to base00", function()
            assert.same({ "base00" }, aliases.map.background)
        end)

        it("maps foreground to base05", function()
            assert.same({ "base05" }, aliases.map.foreground)
        end)

        it("maps bright colors with fallbacks", function()
            assert.same({ "base12", "base08" }, aliases.map.bright_red)
            assert.same({ "base14", "base0B" }, aliases.map.bright_green)
            assert.same({ "base16", "base0D" }, aliases.map.bright_blue)
        end)
    end)

    describe("cterm", function()
        it("has cterm indices for base16 colors", function()
            assert.equal(0, aliases.cterm.base00)
            assert.equal(1, aliases.cterm.base08)
            assert.equal(2, aliases.cterm.base0B)
            assert.equal(4, aliases.cterm.base0D)
            assert.equal(7, aliases.cterm.base05)
            assert.equal(15, aliases.cterm.base07)
        end)

        it("has cterm indices for base24 bright colors", function()
            assert.equal(9, aliases.cterm.base12)
            assert.equal(10, aliases.cterm.base14)
            assert.equal(12, aliases.cterm.base16)
        end)

        it("has nil for unmapped base24 slots", function()
            assert.is_nil(aliases.cterm.base10)
            assert.is_nil(aliases.cterm.base11)
        end)
    end)

    describe("resolve", function()
        it("resolves background alias", function()
            local color, base = aliases.resolve("background", base16_palette)

            assert.equal("#000000", color)
            assert.equal("base00", base)
        end)

        it("resolves foreground alias", function()
            local color, base = aliases.resolve("foreground", base16_palette)

            assert.equal("#555555", color)
            assert.equal("base05", base)
        end)

        it("resolves red alias", function()
            local color, base = aliases.resolve("red", base16_palette)

            assert.equal("#880000", color)
            assert.equal("base08", base)
        end)

        it("resolves bright_red with base24 palette", function()
            local color, base = aliases.resolve("bright_red", base24_palette)

            assert.equal("#ff0000", color)
            assert.equal("base12", base)
        end)

        it("resolves bright_red fallback with base16 palette", function()
            local color, base = aliases.resolve("bright_red", base16_palette)

            assert.equal("#880000", color)
            assert.equal("base08", base)
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
