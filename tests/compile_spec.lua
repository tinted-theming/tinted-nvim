describe("compile", function()
    local compile
    local test_scheme = "base16-test-compile"
    local sep = package.config:sub(1, 1)
    local function get_compiled_path(scheme)
        return table.concat({
            vim.fn.stdpath("state"),
            "tinted-nvim",
            scheme .. ".lua",
        }, sep)
    end

    before_each(function()
        package.loaded["tinted-nvim.compile"] = nil
        compile = require("tinted-nvim.compile")
        local path = get_compiled_path(test_scheme)
        if vim.fn.filereadable(path) == 1 then
            vim.fn.delete(path)
        end
    end)

    after_each(function()
        local path = get_compiled_path(test_scheme)
        if vim.fn.filereadable(path) == 1 then
            vim.fn.delete(path)
        end
    end)

    local test_palette = {
        variant = "dark",
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

    local test_highlights = {
        Normal = { fg = "#555555", bg = "#000000" },
        Comment = { fg = "#333333", italic = true },
    }

    local test_terminal = {
        [0] = "#000000",
        [1] = "#880000",
        [7] = "#555555",
        [15] = "#777777",
    }

    describe("exists", function()
        it("returns false when artifact does not exist", function()
            assert.is_false(compile.exists(test_scheme))
        end)

        it("returns true after writing artifact", function()
            compile.write(test_scheme, test_palette, test_highlights, test_terminal)

            assert.is_true(compile.exists(test_scheme))
        end)
    end)

    describe("write", function()
        it("creates compiled artifact file", function()
            compile.write(test_scheme, test_palette, test_highlights, test_terminal)

            assert.equal(1, vim.fn.filereadable(get_compiled_path(test_scheme)))
        end)

        it("creates parent directory if needed", function()
            local dir = table.concat({ vim.fn.stdpath("state"), "tinted-nvim" }, sep)

            vim.fn.delete(dir, "rf")
            compile.write(test_scheme, test_palette, test_highlights, test_terminal)

            assert.equal(1, vim.fn.isdirectory(dir))
        end)
    end)

    describe("load", function()
        it("returns nil when artifact does not exist", function()
            local result = compile.load("nonexistent-scheme")

            assert.is_nil(result)
        end)

        it("loads and applies highlights, returns palette", function()
            compile.write(test_scheme, test_palette, test_highlights, test_terminal)
            local palette = compile.load(test_scheme)

            assert.is_table(palette)
            assert.equal("#000000", palette.base00)
            assert.equal("#555555", palette.base05)
            assert.equal("dark", palette.variant)
        end)

        it("sets terminal colors when loaded", function()
            compile.write(test_scheme, test_palette, test_highlights, test_terminal)
            compile.load(test_scheme)

            assert.equal("#000000", vim.g.terminal_color_0)
            assert.equal("#880000", vim.g.terminal_color_1)
        end)
    end)

    describe("clear_all", function()
        it("removes all compiled artifacts", function()
            compile.write(test_scheme, test_palette, test_highlights, test_terminal)
            compile.write(test_scheme .. "-2", test_palette, test_highlights, test_terminal)
            assert.is_true(compile.exists(test_scheme))
            assert.is_true(compile.exists(test_scheme .. "-2"))
            compile.clear_all()
            assert.is_false(compile.exists(test_scheme))
            assert.is_false(compile.exists(test_scheme .. "-2"))
        end)

        it("does not error when no artifacts exist", function()
            assert.has_no_error(function()
                compile.clear_all()
            end)
        end)
    end)
end)
