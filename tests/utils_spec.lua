describe("utils", function()
    local utils

    before_each(function()
        package.loaded["tinted-nvim.utils"] = nil
        utils = require("tinted-nvim.utils")
    end)

    describe("blend", function()
        it("blends two colors with 0 amount (returns fg)", function()
            local result = utils.blend("#ff0000", "#0000ff", 0)

            assert.equal("#ff0000", result)
        end)

        it("blends two colors with 1 amount (returns bg)", function()
            local result = utils.blend("#ff0000", "#0000ff", 1)

            assert.equal("#0000ff", result)
        end)

        it("blends two colors with 0.5 amount", function()
            local result = utils.blend("#ff0000", "#0000ff", 0.5)

            assert.equal("#800080", result)
        end)

        it("blends black and white", function()
            local result = utils.blend("#000000", "#ffffff", 0.5)

            assert.equal("#808080", result)
        end)

        it("returns NONE when fg is none", function()
            local result = utils.blend("none", "#000000", 0.5)

            assert.equal("NONE", result)
        end)

        it("returns NONE when fg is NONE (uppercase)", function()
            local result = utils.blend("NONE", "#000000", 0.5)

            assert.equal("NONE", result)
        end)

        it("returns fg when bg is none", function()
            local result = utils.blend("#ff0000", "none", 0.5)

            assert.equal("#ff0000", result)
        end)

        it("clamps amount below 0", function()
            local result = utils.blend("#ff0000", "#0000ff", -1)

            assert.equal("#ff0000", result)
        end)

        it("clamps amount above 1", function()
            local result = utils.blend("#ff0000", "#0000ff", 2)

            assert.equal("#0000ff", result)
        end)

        it("handles nil amount as 0", function()
            local result = utils.blend("#ff0000", "#0000ff", nil)

            assert.equal("#ff0000", result)
        end)
    end)

    describe("darken", function()
        it("darkens a color by blending with background", function()
            local result = utils.darken("#ffffff", 0.5, "#000000")

            assert.equal("#808080", result)
        end)

        it("returns original with 0 amount", function()
            local result = utils.darken("#ff0000", 0, "#000000")

            assert.equal("#ff0000", result)
        end)

        it("returns background with 1 amount", function()
            local result = utils.darken("#ff0000", 1, "#000000")

            assert.equal("#000000", result)
        end)
    end)

    describe("lighten", function()
        it("lightens a color by blending with foreground", function()
            local result = utils.lighten("#000000", 0.5, "#ffffff")

            assert.equal("#808080", result)
        end)

        it("returns original with 0 amount", function()
            local result = utils.lighten("#ff0000", 0, "#ffffff")

            assert.equal("#ff0000", result)
        end)

        it("returns foreground with 1 amount", function()
            local result = utils.lighten("#ff0000", 1, "#ffffff")

            assert.equal("#ffffff", result)
        end)
    end)
end)
