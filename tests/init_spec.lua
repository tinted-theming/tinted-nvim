describe("init", function()
    local tinted = nil

    local function reset_modules()
        package.loaded["tinted-nvim"] = nil
        package.loaded["tinted-nvim.config"] = nil
        package.loaded["tinted-nvim.colors"] = nil
        package.loaded["tinted-nvim.highlights"] = nil
        package.loaded["tinted-nvim.highlights.init"] = nil
        package.loaded["tinted-nvim.highlights.core"] = nil
        package.loaded["tinted-nvim.highlights.syntax"] = nil
        package.loaded["tinted-nvim.highlights.treesitter"] = nil
        package.loaded["tinted-nvim.highlights.lsp"] = nil
        package.loaded["tinted-nvim.highlights.diagnostics"] = nil
        package.loaded["tinted-nvim.terminal"] = nil
        package.loaded["tinted-nvim.compile"] = nil
        package.loaded["tinted-nvim.selector"] = nil
        package.loaded["tinted-nvim.aliases"] = nil
    end

    before_each(function()
        reset_modules()
        vim.g.colors_name = nil
        tinted = require("tinted-nvim")
    end)

    describe("setup", function()
        it("can be called with no arguments", function()
            assert.has_no_error(function()
                tinted.setup()
            end)
        end)

        it("can be called with custom options", function()
            assert.has_no_error(function()
                tinted.setup({
                    default_scheme = "base16-nord",
                    apply_scheme_on_startup = false,
                })
            end)
        end)

        it("applies scheme on startup by default", function()
            tinted.setup({
                apply_scheme_on_startup = true,
            })

            assert.is_string(vim.g.colors_name)
        end)

        it("does not apply scheme when apply_scheme_on_startup is false", function()
            tinted.setup({
                apply_scheme_on_startup = false,
            })

            assert.is_nil(vim.g.colors_name)
        end)

        it("creates TintedNvimCompile command", function()
            local commands = vim.api.nvim_get_commands({})

            tinted.setup({ apply_scheme_on_startup = false })

            assert.is_not_nil(commands.TintedNvimCompile)
        end)

        it("creates TintedNvimClearCache command", function()
            local commands = vim.api.nvim_get_commands({})

            tinted.setup({ apply_scheme_on_startup = false })

            assert.is_not_nil(commands.TintedNvimClearCache)
        end)
    end)

    describe("load", function()
        it("errors when setup has not been called", function()
            tinted = require("tinted-nvim")

            reset_modules()

            assert.has_error(function()
                tinted.load("base16-ayu-dark")
            end, "tinted-nvim: setup() must be called first")
        end)

        it("loads a scheme by name", function()
            tinted.setup({ apply_scheme_on_startup = false })
            tinted.load("base16-nord")

            assert.equal("base16-nord", vim.g.colors_name)
        end)

        it("loads default scheme when no name given", function()
            tinted.setup({
                default_scheme = "base16-dracula",
                apply_scheme_on_startup = false,
            })
            tinted.load()

            assert.equal("base16-dracula", vim.g.colors_name)
        end)

        it("sets termguicolors", function()
            vim.o.termguicolors = false

            tinted.setup({ apply_scheme_on_startup = false })
            tinted.load("base16-ayu-dark")

            assert.is_true(vim.o.termguicolors)
        end)

        it("clears existing highlights", function()
            vim.g.colors_name = "old-scheme"

            tinted.setup({ apply_scheme_on_startup = false })
            tinted.load("base16-nord")

            assert.equal("base16-nord", vim.g.colors_name)
        end)

        it("fires ColorScheme autocmd by default", function()
            local fired = false
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    fired = true
                end,
                once = true,
            })

            tinted.setup({ apply_scheme_on_startup = false })
            tinted.load("base16-ayu-dark")

            assert.is_true(fired)
        end)

        it("can suppress ColorScheme autocmd", function()
            local fired = false
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    fired = true
                end,
                once = true,
            })

            tinted.setup({ apply_scheme_on_startup = false })
            tinted.load("base16-ayu-dark", { colorscheme_event = false })

            assert.is_false(fired)
        end)
    end)

    describe("compile", function()
        it("errors when setup has not been called", function()
            tinted = require("tinted-nvim")
            reset_modules()

            assert.has_error(function()
                tinted.compile("base16-ayu-dark")
            end, "tinted-nvim: setup() must be called first")
        end)

        it("compiles a scheme without applying it", function()
            local compile = require("tinted-nvim.compile")

            tinted.setup({ apply_scheme_on_startup = false, compile = true })
            tinted.compile("base16-ayu-dark")

            assert.is_nil(vim.g.colors_name)
            assert.is_true(compile.exists("base16-ayu-dark"))
            compile.clear_all()
        end)
    end)

    describe("clear_cache", function()
        it("clears compiled artifacts", function()
            local compile = require("tinted-nvim.compile")

            tinted.setup({ apply_scheme_on_startup = false, compile = true })
            tinted.compile("base16-ayu-dark")
            assert.is_true(compile.exists("base16-ayu-dark"))
            tinted.clear_cache()

            assert.is_false(compile.exists("base16-ayu-dark"))
        end)
    end)

    describe("get_* accessors", function()
        it("get_palette errors before setup", function()
            tinted = require("tinted-nvim")
            reset_modules()

            assert.has_error(function()
                tinted.get_palette()
            end, "tinted-nvim: setup() must be called first")
        end)

        it("get_palette returns nil before load", function()
            tinted.setup({ apply_scheme_on_startup = false })

            assert.is_nil(tinted.get_palette())
        end)

        it("get_palette returns palette after load", function()
            tinted.setup({ apply_scheme_on_startup = false })
            tinted.load("base16-ayu-dark")

            assert.is_table(tinted.get_palette())
            assert.is_string(tinted.get_palette().base00)
        end)

        it("get_scheme returns nil before load", function()
            tinted.setup({ apply_scheme_on_startup = false })

            assert.is_nil(tinted.get_scheme())
        end)

        it("get_scheme returns scheme name after load", function()
            tinted.setup({ apply_scheme_on_startup = false })
            tinted.load("base16-nord")

            assert.equal("base16-nord", tinted.get_scheme())
        end)

        it("get_palette_aliases returns nil before load", function()
            tinted.setup({ apply_scheme_on_startup = false })

            assert.is_nil(tinted.get_palette_aliases())
        end)

        it("get_palette_aliases returns aliases after load", function()
            tinted.setup({ apply_scheme_on_startup = false })
            tinted.load("base16-ayu-dark")

            assert.is_table(tinted.get_palette_aliases())
            assert.is_string(tinted.get_palette_aliases().background)
            assert.is_string(tinted.get_palette_aliases().foreground)
        end)
    end)
end)
