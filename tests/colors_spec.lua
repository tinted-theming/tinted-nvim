describe("colors", function()
    local colors

    before_each(function()
        package.loaded["tinted-nvim.colors"] = nil
        colors = require("tinted-nvim.colors")
    end)

    describe("resolve", function()
        it("errors on invalid scheme-system prefix", function()
            local scheme_system = "invalid-scheme-system"

            assert.has_error(
                function()
                    colors.resolve(scheme_system, {})
                end,
                "tinted-nvim: invalid scheme-system '"
                    .. scheme_system
                    .. "' (must start with 'base16-', 'base24-', or 'tinted8-')"
            )
        end)

        it("errors on unknown scheme without user definition", function()
            assert.has_error(function()
                colors.resolve("base16-nonexistent-scheme-xyz", {})
            end)
        end)

        it("loads a builtin base16 palette", function()
            local palette = colors.resolve("base16-ayu-dark", {})

            assert.is_table(palette)
            assert.is_string(palette.base00)
            assert.is_string(palette.base05)
            assert.is_string(palette.base0F)
            assert.equal("dark", palette.variant)
        end)

        it("loads a builtin base24 palette", function()
            local palette = colors.resolve("base24-dracula", {})

            assert.is_table(palette)
            assert.is_string(palette.base00)
            assert.is_string(palette.base17)
            assert.equal("dark", palette.variant)
        end)

        it("validates base16 has all required colors", function()
            local cfg = {
                schemes = {
                    ["base16-incomplete"] = {
                        variant = "dark",
                        base00 = "#000000",
                    },
                },
            }

            assert.has_error(function()
                colors.resolve("base16-incomplete", cfg)
            end)
        end)

        it("validates base24 has all required colors", function()
            local cfg = {
                schemes = {
                    ["base24-incomplete"] = {
                        variant = "dark",
                        base00 = "#000000",
                    },
                },
            }

            assert.has_error(function()
                colors.resolve("base24-incomplete", cfg)
            end)
        end)

        it("errors on missing variant field", function()
            local cfg = {
                schemes = {
                    ["base16-novariant"] = {
                        base00 = "#000000",
                        base01 = "#111111",
                        base02 = "#222222",
                        base03 = "#333333",
                        base04 = "#444444",
                        base05 = "#555555",
                        base06 = "#666666",
                        base07 = "#777777",
                        base08 = "#888888",
                        base09 = "#999999",
                        base0A = "#aaaaaa",
                        base0B = "#bbbbbb",
                        base0C = "#cccccc",
                        base0D = "#dddddd",
                        base0E = "#eeeeee",
                        base0F = "#ffffff",
                    },
                },
            }

            assert.has_error(function()
                colors.resolve("base16-novariant", cfg)
            end)
        end)

        it("applies user overrides to builtin palette", function()
            local cfg = {
                schemes = {
                    ["base16-ayu-dark"] = {
                        base00 = "#112233",
                    },
                },
            }

            local palette = colors.resolve("base16-ayu-dark", cfg)
            assert.equal("#112233", palette.base00)
        end)

        it("supports function overrides", function()
            local cfg = {
                schemes = {
                    ["base16-ayu-dark"] = {
                        base00 = function(p)
                            return p.base01
                        end,
                    },
                },
            }

            local palette = colors.resolve("base16-ayu-dark", cfg)
            assert.is_string(palette.base00)
        end)

        it("override callback receives palette tree for tinted8 schemes", function()
            package.preload["tinted-nvim.palettes.tinted8-test"] = function()
                return dofile("tests/fixtures/tinted8_scheme.lua")
            end

            local scheme
            local cfg = {
                schemes = {
                    ["tinted8-test"] = {
                        variant = function(p)
                            scheme = p
                            return p.variant
                        end,
                    },
                },
            }

            colors.resolve("tinted8-test", cfg)
            package.preload["tinted-nvim.palettes.tinted8-test"] = nil

            assert.is_table(scheme.palette, "tinted8 override callback should have palette tree")
            assert.is_string(scheme.palette.red.normal, "tinted8 override callback should have palette.red.normal")
            assert.is_table(scheme.ui, "tinted8 override callback should have ui tree")
            assert.is_table(scheme.syntax, "tinted8 override callback should have syntax tree")
        end)

        it("override callback receives palette tree for base16 schemes", function()
            local received_palette
            local cfg = {
                schemes = {
                    ["base16-ayu-dark"] = {
                        base00 = function(p)
                            received_palette = p
                            return p.base00
                        end,
                    },
                },
            }

            colors.resolve("base16-ayu-dark", cfg)

            assert.is_table(received_palette.palette, "base16 override callback should have palette tree")
            assert.is_string(
                received_palette.palette.red.normal,
                "base16 override callback should have palette.red.normal"
            )
            assert.is_table(received_palette.ui, "base16 override callback should have ui tree")
            assert.is_table(received_palette.syntax, "base16 override callback should have syntax tree")
        end)

        it("allows fully user-defined scheme", function()
            local cfg = {
                schemes = {
                    ["base16-custom"] = {
                        variant = "dark",
                        base00 = "#000000",
                        base01 = "#111111",
                        base02 = "#222222",
                        base03 = "#333333",
                        base04 = "#444444",
                        base05 = "#555555",
                        base06 = "#666666",
                        base07 = "#777777",
                        base08 = "#888888",
                        base09 = "#999999",
                        base0A = "#aaaaaa",
                        base0B = "#bbbbbb",
                        base0C = "#cccccc",
                        base0D = "#dddddd",
                        base0E = "#eeeeee",
                        base0F = "#ffffff",
                    },
                },
            }

            local palette = colors.resolve("base16-custom", cfg)

            assert.equal("#000000", palette.base00)
            assert.equal("dark", palette.variant)
        end)
    end)
end)
