-- Compatibility shim for the legacy module name `tinted-colorscheme`.
-- This prevents errors in older configurations that still reference the
-- deprecated module. It will be removed in a future release.

local M = {}

local warned_key = "tinted_nvim_legacy_import_warned"

if vim and vim.g and not vim.g[warned_key] then
    vim.g[warned_key] = true
    vim.notify_once(
        "Deprecated module 'tinted-colorscheme' was loaded.\n"
            .. "This plugin was rewritten and renamed to 'tinted-nvim', and its API has changed.\n"
            .. "Please review the documentation to learn about the new features and configuration.\n"
            .. "See :h tinted-nvim or the README at https://github.com/tinted-theming/tinted-nvim",
        vim.log.levels.WARN
    )
end

function M.setup() end

function M.with_config() end

function M.available_colorschemes() end

M.colors = {}

return M
