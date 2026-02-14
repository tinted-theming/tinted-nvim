describe("terminal", function()
    local terminal

    before_each(function()
        package.loaded["tinted-nvim.terminal"] = nil
        terminal = require("tinted-nvim.terminal")
        for i = 0, 17 do
            vim.g["terminal_color_" .. i] = nil
        end
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

    describe("build", function()
        it("returns nil when terminal_colors is disabled", function()
            local cfg = {
                capabilities = { terminal_colors = false },
            }
            local result = terminal.build(base16_palette, cfg)

            assert.is_nil(result)
        end)

        it("returns nil when capabilities is nil", function()
            local cfg = {}
            local result = terminal.build(base16_palette, cfg)

            assert.is_nil(result)
        end)

        it("builds terminal colors from base16 palette", function()
            local cfg = {
                capabilities = { terminal_colors = true },
            }
            local result = terminal.build(base16_palette, cfg)

            assert.is_table(result)
            assert.equal("#000000", result[0])
            assert.equal("#880000", result[1])
            assert.equal("#00ff00", result[2])
            assert.equal("#ffff00", result[3])
            assert.equal("#0000ff", result[4])
            assert.equal("#ff00ff", result[5])
            assert.equal("#00ffff", result[6])
            assert.equal("#555555", result[7])
        end)

        it("builds bright colors from base16 (fallback)", function()
            local cfg = {
                capabilities = { terminal_colors = true },
            }
            local result = terminal.build(base16_palette, cfg)

            assert.equal("#333333", result[8])
            assert.equal("#880000", result[9])
            assert.equal("#00ff00", result[10])
            assert.equal("#ffff00", result[11])
            assert.equal("#0000ff", result[12])
            assert.equal("#ff00ff", result[13])
            assert.equal("#00ffff", result[14])
            assert.equal("#777777", result[15])
        end)

        it("builds bright colors from base24 palette", function()
            local cfg = {
                capabilities = { terminal_colors = true },
            }
            local result = terminal.build(base24_palette, cfg)

            assert.equal("#ff0000", result[9])
            assert.equal("#00ff00", result[10])
            assert.equal("#ffff00", result[11])
            assert.equal("#0000ff", result[12])
            assert.equal("#ff00ff", result[13])
            assert.equal("#00ffff", result[14])
        end)

        it("builds extended ANSI colors", function()
            local cfg = {
                capabilities = { terminal_colors = true },
            }
            local result = terminal.build(base16_palette, cfg)

            assert.equal("#ff9900", result[16])
            assert.equal("#880000", result[17])
        end)
    end)

    describe("apply", function()
        it("does nothing when term is nil", function()
            terminal.apply(nil)
            assert.is_nil(vim.g.terminal_color_0)
        end)

        it("sets terminal_color_N globals", function()
            local term = {
                [0] = "#000000",
                [1] = "#ff0000",
                [7] = "#ffffff",
                [15] = "#ffffff",
            }

            terminal.apply(term)

            assert.equal("#000000", vim.g.terminal_color_0)
            assert.equal("#ff0000", vim.g.terminal_color_1)
            assert.equal("#ffffff", vim.g.terminal_color_7)
            assert.equal("#ffffff", vim.g.terminal_color_15)
        end)

        it("sets all 18 terminal colors", function()
            local cfg = {
                capabilities = { terminal_colors = true },
            }
            local term = terminal.build(base16_palette, cfg)

            terminal.apply(term)

            for i = 0, 17 do
                assert.is_string(vim.g["terminal_color_" .. i])
            end
        end)
    end)
end)
