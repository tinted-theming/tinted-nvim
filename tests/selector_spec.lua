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

    describe("watch on a live file", function()
        local uv = vim.uv or vim.loop
        local dir, target, file

        local handles = dofile("tests/fixtures/handle_tracker.lua")

        local function open_watchers()
            return handles.open("fs_event")
        end

        local function cfg()
            return {
                default_scheme = "base16-default",
                selector = { enabled = true, mode = "file", path = file, watch = true },
            }
        end

        -- Replace the directory holding the selector file, the way
        -- `tinty apply` does: build a staging dir, remove the target, rename.
        -- `gap_ms` holds the file missing for a while in between.
        local function swap(name, gap_ms)
            local staging = dir .. "/staging"
            vim.fn.mkdir(staging, "p")
            vim.fn.writefile({ name }, staging .. "/current_scheme")
            vim.fn.delete(target, "rf")
            if gap_ms then
                vim.wait(gap_ms)
            end
            assert(uv.fs_rename(staging, target))
        end

        local function start(seen)
            selector.watch(cfg(), function(name)
                table.insert(seen, name)
            end)
            -- let the event loop register the watcher
            vim.wait(100)
        end

        local function wait_for(seen, name)
            return vim.wait(2000, function()
                return seen[#seen] == name
            end, 10)
        end

        before_each(function()
            handles.install()
            dir = vim.fn.tempname()
            target = dir .. "/artifacts"
            file = target .. "/current_scheme"
            vim.fn.mkdir(target, "p")
            vim.fn.writefile({ "base16-one" }, file)
        end)

        after_each(function()
            selector.stop()
            handles.restore()
            vim.fn.delete(dir, "rf")
        end)

        it("reports a change written in place", function()
            local seen = {}
            start(seen)

            vim.fn.writefile({ "base16-two" }, file)

            assert.is_true(wait_for(seen, "base16-two"))
            assert.same({ "base16-two" }, seen)
        end)

        it("keeps a single watcher when the file is replaced repeatedly", function()
            local before = open_watchers()
            local seen = {}
            start(seen)
            assert.equal(before + 1, open_watchers())

            local names = { "base16-two", "base16-three", "base16-four", "base16-five" }
            for _, name in ipairs(names) do
                swap(name)
                assert.is_true(wait_for(seen, name))
                -- let any trailing events settle
                vim.wait(200)
                assert.equal(before + 1, open_watchers())
            end

            assert.same(names, seen)
        end)

        it("does not fall back to default_scheme while the file is missing", function()
            local seen = {}
            start(seen)

            swap("base16-two", 300)

            assert.is_true(wait_for(seen, "base16-two"))
            assert.same({ "base16-two" }, seen)

            -- the watcher was re-armed on the new file
            vim.wait(200)
            vim.fn.writefile({ "base16-three" }, file)
            assert.is_true(wait_for(seen, "base16-three"))
        end)

        it("closes the watcher on stop", function()
            local before = open_watchers()
            start({})
            assert.equal(before + 1, open_watchers())

            selector.stop()

            assert.equal(before, open_watchers())
        end)

        it("keeps a single watcher when the module is reloaded", function()
            local seen = {}
            start({})

            -- what a plugin manager's hot reload does
            package.loaded["tinted-nvim.selector"] = nil
            selector = require("tinted-nvim.selector")
            start(seen)

            assert.equal(1, open_watchers())
            assert.equal(1, handles.open("timer"))

            -- the reloaded module owns the watcher and can stop it
            selector.stop()
            assert.equal(0, open_watchers())
            assert.equal(0, handles.open("timer"))

            -- and watching works again from the reloaded module
            start(seen)
            vim.fn.writefile({ "base16-two" }, file)
            assert.is_true(wait_for(seen, "base16-two"))
            assert.same({ "base16-two" }, seen)
        end)

        it("can watch again after stop", function()
            local seen = {}
            start({})
            selector.stop()
            start(seen)

            vim.fn.writefile({ "base16-two" }, file)

            assert.is_true(wait_for(seen, "base16-two"))
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
