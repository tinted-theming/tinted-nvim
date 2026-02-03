# tinted-nvim

Neovim colorscheme plugin that bundles all Base16/Base24 schemes from the
[tinted-theming] project. For the smoothest workflow, use [Tinty] alongside
`tinted-nvim`.

Preview themes in the [Tinted Gallery].

## Features

- Base16/Base24 palette support with built-in and user-defined schemes
- Override schemes and highlight groups
- Color transforms (`darken` / `lighten`) for fine-tuning
- Color aliases for readability
- Compile highlights for faster startup
- Selector support: read scheme from file, env var, or command output
- Auto-switch when terminal scheme changes (with `watch`)
- Optional highlight integrations for popular Neovim plugins
- Lazy.nvim integration: define highlights in your plugin spec for modularity

## Installation

### lazy.nvim

```lua
{
  "tinted-nvim",
  lazy = false,
  opts = {
    -- your config overrides
  }
}
```

### Manual

```lua
require("tinted-nvim").setup({
  -- your config overrides
})
```

## Usage

- Load a built-in scheme via `:colorscheme` (does not work for custom schemes):

  ```vim
  :colorscheme base16-catppuccin-frappe
  ```

- Load any scheme programmatically (built-in or custom):

  ```lua
  require("tinted-nvim").load("base16-my-custom-scheme")
  ```

## Configuration

Everything is configured through a single `setup()` call.

**Note**: the following section is a showcase of possible configuration
options. **Don't copy/paste this config**. It is meant for understanding. The
default config is here: [lua/tinted-nvim/config.lua].

```lua
require("tinted-nvim").setup({
  -- Fallback scheme (used when selector cannot resolve a scheme).
  default_scheme = "base16-ayu-dark",

  -- Apply a scheme automatically during startup.
  apply_scheme_on_startup = true,

  -- Compile the scheme for faster startup.
  compile = true,

  capabilities = {
    -- Enable truecolor support (sets `termguicolors`).
    -- If false, cterm colors are used where available.
    truecolor = true,

    -- Some terminal emulators cannot draw undercurls. When disabling
    -- undercurls globally, it falls back to underline.
    undercurl = false,

    -- Set vim.g.terminal_color_0 .. vim.g.terminal_color_17.
    terminal_colors = true,
  },

  ui = {
    -- If true, Normal background is left unset (transparent).
    transparent = false,

    -- Dim background of inactive windows.
    dim_inactive = false,
  },

  -- Change text attributes for certain highlight groups.
  -- Supported attributes: italic, bold, underline, undercurl, strikethrough.
  styles = {
    comments  = { italic = true },
    keywords  = { bold = true },
    functions = { underline = true },
    variables = { italic = true, underline = true },
    types     = { bold = true, underline = true, strikethrough = false },
  },

  highlights = {
    -- This plugin bundles highlight definitions for popular Neovim plugins.
    -- Enable/disable them as needed. This only enables highlight groups, not
    -- the plugin itself.
    integrations = {
      telescope = true,
      notify    = true,
      cmp       = true,
      blink     = true,
      dapui     = true,
      lualine   = true,
    },

    -- If enabled, the plugin will scan all lazy.nvim specs and merge any
    -- `highlights = { ... }` tables it finds. This lets you keep plugin-specific
    -- highlights close to their plugin definitions instead of in a global
    -- overrides table.
    -- Example:
    -- {
    --   "folke/todo-comments.nvim",
    --   opts = {},
    --   highlights = {
    --     Todo = { fg = "yellow", bg = "#00ff00", bold = true },
    --   },
    -- }
    use_lazy_specs = true,

    -- This callback function lets you override highlight groups (just like
    -- `use_lazy_specs` does).
    overrides = function(palette)
      return {
        -- Set hex rgb values explicitly.
        Normal = { bg = "#ff0000" },

        -- Link to another hlgroup.
        NormalFloat = { link = "Normal" },

        -- Access the current palette and its baseXX colors.
        FloatBorder = { fg = palette.base03 },

        -- Use color aliases.
        CursorLine = { bg = "darkest_grey", fg = "foreground" },

        -- Use darken / lighten to change a color.
        Search = {
          bg = { darken = palette.base07, amount = 0.3 },
          fg = { lighten = "#00ff00", amount = 0.1 },
        },

        -- Any other attribute allowed by nvim.api.nvim_set_hl().
        DiagnosticUnderlineError = { undercurl = true, sp = "bright_red" },

        -- Clear or reset a group by returning an empty table.
        StatusLine = {},
      }
    end,
  },

  schemes = {
    -- Override specific colors of an existing scheme.
    ["base16-catppuccin-mocha"] = {
      -- Override with explicit color.
      base08 = "#ff0000",
      -- Use a function callback to define a new color.
      base0A = function(palette)
        return palette.base0B
      end,
    },

    -- Define a completely new Base16/Base24-style scheme.
    -- Custom schemes must start with base16- or base24-.
    ["base16-my-theme"] = {
      variant = "dark",
      base00 = "#000000",
      base01 = "#111111",
      base02 = "#222222",
      base03 = "#333333",
      base04 = "#444444",
      base05 = "#cccccc",
      base06 = "#eeeeee",
      base07 = "#ffffff",
      base08 = "#ff5555",
      base09 = "#ffb86c",
      base0A = "#f1fa8c",
      base0B = "#50fa7b",
      base0C = "#8be9fd",
      base0D = "#bd93f9",
      base0E = "#ff79c6",
      base0F = "#ff5555",
    },
  },

  -- External scheme selector (resolves scheme names only).
  selector = {
    enabled = true,

    -- "file" | "env" | "cmd"
    mode = "file",

    -- Expects a file that only contains the scheme name.
    path = "~/.local/share/tinted-theming/tinty/current_scheme",

    -- Reads the scheme name from an environment variable.
    env = "TINTED_THEME",

    -- Executes a command that returns the scheme name.
    cmd = "tinty current",

    -- In "file" mode: watch the file, and reload the scheme on changes.
    watch = true,
  },
})
```

## Commands

- `:TintedNvimCompile [scheme]` - Compile a scheme. If no argument, compile the
  current scheme.
- `:TintedNvimClearCache` - Delete the cache with all compiled schemes.

## API

- `require("tinted-nvim").get_scheme()` - returns the current scheme name.
- `require("tinted-nvim").get_palette()` - returns the current Base16/Base24 palette.
- `require("tinted-nvim").get_palette_aliases()` - returns the palette using color aliases.

## Troubleshooting

- Truecolor support: this plugin is optimized for truecolor terminals. If you
  are in a non-truecolor terminal, set `capabilities.truecolor = false` to fall
  back to terminal ANSI colors. If you use [tinted-terminal](https://github.com/tinted-theming/tinted-terminal) or
  [tinted-shell](https://github.com/tinted-theming/tinted-shell), your terminal ANSI colors match the Base16/Base24 palette, so
  colors stay consistent. Transforms (darken/lighten) and custom RGB overrides
  do not have `cterm` equivalents, so those highlight groups are skipped.

- Highlights not updating when `compile = true`? Run `:TintedNvimClearCache`.
- Plugin highlights not taking effect? Ensure the integration is enabled in
  `highlights.integrations` or defined in your `overrides`.

## Contributing

For general contribution information, see [CONTRIBUTING.md], which contains
building and contributing instructions.

This project uses [Nix] flakes for reproducible development environments and
[just] as a command runner.

### Setup

```sh
# Enter the development shell (provides luajit, vusted, just)
nix develop

# Or use direnv for automatic shell activation
direnv allow # Which runs .envrc
```

### Commands

```sh
# Run all tests
just test

# Run tests matching a pattern
just test "loads a specific test"

# Run a specific test file
just test-file tests/config_spec.lua
```

### Project structure

```
lua/tinted-nvim/
  init.lua          # Main entry point
  config.lua        # Default configuration
  colors.lua        # Palette resolver
  compile.lua       # Bytecode compilation
  selector.lua      # External scheme selector
  highlights/       # Highlight group builders
  palettes/         # Built-in Base16/Base24 palettes
  aliases.lua       # Color alias mappings
  terminal.lua      # Terminal color mapping
  utils.lua         # Utility functions
tests/              # Test suite (vusted)
```

## Changelog

All notable changes to this project will be documented in [CHANGELOG.md].

The format is based on [Keep a Changelog], and this project adheres to
[Semantic Versioning].

[Nix]: https://nixos.org/
[just]: https://github.com/casey/just
[tinted-theming]: https://github.com/tinted-theming/
[Tinty]: https://github.com/tinted-theming/tinty
[Tinted Gallery]: https://tinted-theming.github.io/tinted-gallery/
[lua/tinted-nvim/config.lua]: lua/tinted-nvim/config.lua
[CHANGELOG.md]: ./CHANGELOG.md
[Keep a Changelog]: https://keepachangelog.com/en/1.1.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
[CONTRIBUTING.md]: https://github.com/tinted-theming/home/blob/main/CONTRIBUTING.md
