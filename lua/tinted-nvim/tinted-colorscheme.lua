-- Compatibility shim for the legacy module name `tinted-colorscheme`.
-- This exists to keep older configs working during migration.
-- It will be removed in a future release.
local warned_key = "tinted_nvim_legacy_import_warned"

if vim and vim.g and not vim.g[warned_key] then
    vim.g[warned_key] = true
    vim.notify_once(
        "Deprecated module 'tinted-colorscheme' was loaded.\n"
            .. "This plugin was renamed to 'tinted-nvim' and its API has changed.\n"
            .. "See :h tinted-nvim for documentation.",
        vim.log.levels.WARN
    )
end

return require("tinted-nvim")
