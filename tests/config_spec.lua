describe("config", function()
    local config

    before_each(function()
        package.loaded["tinted-nvim.config"] = nil
        config = require("tinted-nvim.config")
    end)

    describe("defaults", function()
        it("has expected default values", function()
            assert.equal("base16-ayu-dark", config.defaults.default_scheme)
            assert.is_true(config.defaults.apply_scheme_on_startup)
            assert.is_false(config.defaults.compile)
            assert.is_false(config.defaults.capabilities.undercurl)
            assert.is_true(config.defaults.capabilities.terminal_colors)
            assert.is_false(config.defaults.ui.transparent)
            assert.is_false(config.defaults.ui.dim_inactive)
        end)

        it("has default styles", function()
            assert.is_table(config.defaults.styles.comments)
            assert.is_true(config.defaults.styles.comments.italic)
            assert.is_table(config.defaults.styles.keywords)
            assert.is_table(config.defaults.styles.functions)
            assert.is_table(config.defaults.styles.variables)
            assert.is_table(config.defaults.styles.types)
        end)

        it("has default highlight integrations", function()
            local integrations = config.defaults.highlights.integrations

            assert.is_true(integrations.telescope)
            assert.is_true(integrations.notify)
            assert.is_true(integrations.cmp)
            assert.is_true(integrations.blink)
            assert.is_true(integrations.dapui)
        end)

        it("has default selector config", function()
            local sel = config.defaults.selector

            assert.is_false(sel.enabled)
            assert.equal("file", sel.mode)
            assert.is_true(sel.watch)
        end)
    end)

    describe("metatable", function()
        it("returns defaults via rawget when options is nil", function()
            assert.is_nil(rawget(config, "options"))
            assert.is_table(config.defaults)
            assert.equal("base16-ayu-dark", config.defaults.default_scheme)
        end)

        it("returns options after setup", function()
            local opts = { default_scheme = "base16-dracula" }
            config.options = vim.tbl_deep_extend("force", {}, config.defaults, opts or {})

            assert.equal("base16-dracula", config.options.default_scheme)
        end)
    end)
end)
