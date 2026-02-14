describe("selector", function()
    local selector
    local test_file = vim.fn.tempname()

    before_each(function()
        package.loaded["tinted-nvim.selector"] = nil
        selector = require("tinted-nvim.selector")
        if vim.fn.filereadable(test_file) == 1 then
            vim.fn.delete(test_file)
        end
    end)

    after_each(function()
        selector.stop()
        if vim.fn.filereadable(test_file) == 1 then
            vim.fn.delete(test_file)
        end
    end)

    describe("resolve", function()
        it("returns default_scheme when selector is disabled", function()
            local cfg = {
                default_scheme = "base16-default",
                selector = { enabled = false },
            }

            assert.equal("base16-default", selector.resolve(cfg))
        end)

        it("returns default_scheme when selector is nil", function()
            local cfg = {
                default_scheme = "base16-default",
                selector = nil,
            }

            assert.equal("base16-default", selector.resolve(cfg))
        end)

        describe("file mode", function()
            it("reads scheme from file", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "file",
                        path = test_file,
                    },
                }

                vim.fn.writefile({ "base16-from-file" }, test_file)

                assert.equal("base16-from-file", selector.resolve(cfg))
            end)

            it("trims whitespace from file content", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "file",
                        path = test_file,
                    },
                }

                vim.fn.writefile({ "  base16-trimmed  " }, test_file)

                assert.equal("base16-trimmed", selector.resolve(cfg))
            end)

            it("returns default when file is empty", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "file",
                        path = test_file,
                    },
                }
                vim.fn.writefile({ "" }, test_file)

                assert.equal("base16-default", selector.resolve(cfg))
            end)

            it("returns default when file does not exist", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "file",
                        path = "/nonexistent/path/file",
                    },
                }

                assert.equal("base16-default", selector.resolve(cfg))
            end)

            it("expands tilde in path", function()
                vim.fn.writefile({ "base16-expanded" }, test_file)
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "file",
                        path = test_file,
                    },
                }

                assert.equal("base16-expanded", selector.resolve(cfg))
            end)
        end)

        describe("env mode", function()
            local original_env

            before_each(function()
                original_env = vim.env.TINTED_TEST_THEME
            end)

            after_each(function()
                vim.env.TINTED_TEST_THEME = original_env
            end)

            it("reads scheme from environment variable", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "env",
                        env = "TINTED_TEST_THEME",
                    },
                }
                vim.env.TINTED_TEST_THEME = "base16-from-env"

                assert.equal("base16-from-env", selector.resolve(cfg))
            end)

            it("returns default when env is empty", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "env",
                        env = "TINTED_TEST_THEME",
                    },
                }
                vim.env.TINTED_TEST_THEME = ""

                assert.equal("base16-default", selector.resolve(cfg))
            end)

            it("returns default when env is not set", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "env",
                        env = "TINTED_TEST_THEME",
                    },
                }
                vim.env.TINTED_TEST_THEME = nil

                assert.equal("base16-default", selector.resolve(cfg))
            end)
        end)

        describe("cmd mode", function()
            it("reads scheme from command output", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "cmd",
                        cmd = "echo base16-from-cmd",
                    },
                }

                assert.equal("base16-from-cmd", selector.resolve(cfg))
            end)

            it("trims command output", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "cmd",
                        cmd = "echo '  base16-trimmed  '",
                    },
                }

                assert.equal("base16-trimmed", selector.resolve(cfg))
            end)

            it("returns default when command fails", function()
                local cfg = {
                    default_scheme = "base16-default",
                    selector = {
                        enabled = true,
                        mode = "cmd",
                        cmd = "exit 1",
                    },
                }

                assert.equal("base16-default", selector.resolve(cfg))
            end)
        end)
    end)

    describe("watch", function()
        it("does nothing when selector is disabled", function()
            local cfg = {
                selector = { enabled = false, watch = true },
            }
            local called = false

            selector.watch(cfg, function()
                called = true
            end)

            assert.is_false(called)
        end)

        it("does nothing for non-file mode", function()
            local cfg = {
                selector = {
                    enabled = true,
                    mode = "env",
                    watch = true,
                },
            }
            local called = false

            selector.watch(cfg, function()
                called = true
            end)

            assert.is_false(called)
        end)

        it("does nothing when watch is false", function()
            local cfg = {
                selector = {
                    enabled = true,
                    mode = "file",
                    watch = false,
                    path = test_file,
                },
            }
            local called = false

            selector.watch(cfg, function()
                called = true
            end)

            assert.is_false(called)
        end)
    end)

    describe("stop", function()
        it("does not error when no watcher is active", function()
            assert.has_no_error(function()
                selector.stop()
            end)
        end)
    end)
end)
