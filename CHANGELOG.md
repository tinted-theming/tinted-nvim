# Changelog

## [0.1.0] - 2026-02-01

### Added

- **Modular architecture**: Complete rewrite with clean module separation (`config`, `colors`, `compile`, `selector`, `highlights`, `terminal`, `aliases`, `utils`)
- **Compile-to-bytecode**: Compile schemes to Lua bytecode for faster startup with `compile = true`
- **External selector**: Read scheme from file, environment variable, or command output
- **File watcher**: Automatically reload scheme when selector file changes (with `watch = true`)
- **Color transforms**: `darken` and `lighten` functions for fine-tuning colors in highlight overrides
- **Color aliases**: Use semantic names like `red`, `background`, `foreground` instead of `base08`, `base00`, `base05`
- **Highlight integrations**: Built-in support for telescope, notify, cmp, blink, dapui
- **Lazy.nvim highlight specs**: Define highlights in plugin specs with `use_lazy_specs = true`
- **User-defined schemes**: Create custom Base16/Base24 schemes in config
- **Scheme overrides**: Override specific colors of existing schemes
- **Style customization**: Configure text attributes for comments, keywords, functions, variables, types
- **UI options**: `transparent` background and `dim_inactive` windows
- **Terminal colors**: Proper Base16/Base24 to ANSI color mapping with Base24 bright color support
- **Commands**: `:TintedNvimCompile` and `:TintedNvimClearCache`
- **API functions**: `get_scheme()`, `get_palette()`, `get_palette_aliases()`
- **Test suite**: Comprehensive tests using vusted
- **Type annotations**: LuaDoc comments throughout codebase

### Changed

- **Module structure**: Moved from `lua/tinted-colorscheme.lua` monolith to `lua/tinted-nvim/` directory with separate modules
- **Palette location**: Moved from `lua/colors/` to `lua/tinted-nvim/palettes/`
- **Configuration**: New `setup()` options structure (see README.md)
- **API**: Changed from property access (`tinted.palette`) to function calls (`tinted.get_palette()`)

### Removed

- **Old highlight system**: Replaced `M.highlight` metatable with declarative highlight builders
- **Direct Tinty dependency**: Replaced with generic selector system that works with any scheme source

### Fixed

- Proper `vim.g.colors_name` handling
- ColorScheme autocmd firing with suppression option
- Base24 bright color fallbacks to Base16 equivalents
