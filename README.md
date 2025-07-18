# tinted-nvim

Neovim plugin for building Tinted Theming colorschemes with support for Neovim's
builtin LSP and Treesitter.

For smoothest usage, we recommend using [Tinty] in conjunction with
`tinted-nvim`.

Have a look at [Tinted Gallery] for a preview of our themes.

# 🚀 Quickstart

```lua
-- Enable true color support (recommended)
vim.opt.termguicolors = true

-- Load the colorscheme
require('tinted-colorscheme').setup('base16-ayu-dark')

-- Or use any available theme via `:colorscheme`
vim.cmd.colorscheme('base16-ayu-dark')
```

## 📦 Installation

To get the most accurate colors and full Base24 support, enable true color in
your Neovim config:

```lua
vim.opt.termguicolors = true
```

### lazy.nvim

```lua
return {
  "tinted-theming/tinted-nvim",
}
```

### Packer

```lua
use {
  'tinted-theming/tinted-nvim',
}
```

### vim-plug

```lua
Plug 'tinted-theming/tinted-nvim'
```

## 🧪 Basic Usage

```lua
-- All builtin colorschemes can be accessed with |:colorscheme|.
vim.cmd.colorscheme('base16-ayu-dark')
```

## 🔧 Advanced Usage

### ⚙️ Configuration Options

The `require('tinted-colorscheme').setup()` function can be called with two
optional arguments: a theme or a config table.

#### Colors Parameter (optional)

| Type        | Description                                                                                                    |
| ----------- | -------------------------------------------------------------------------------------------------------------- |
| `string`    | Name of a registered theme (e.g. "base16-ayu-dark")                                                            |
| `table`     | A custom Base16/Base24 color table with keys from `base00` to `base17`                                         |
| `undefined` | If omitted, will try to detect a theme from [Tinty], or fall back to "tinted-nvim-default" (`base16-ayu-dark`) |

**Examples**:

- `string`: `require('tinted-colorscheme').setup('base16-ayu-dark')`
- `table`:
  ```lua
  require('tinted-colorscheme').setup({
    base00 = "#0f1419", base01 = "#131721", base02 = "#272d38", base03 = "#3e4b59",
    base04 = "#bfbdb6", base05 = "#e6e1cf", base06 = "#e6e1cf", base07 = "#f3f4f5",
    base08 = "#f07178", base09 = "#ff8f40", base0A = "#ffb454", base0B = "#b8cc52",
    base0C = "#95e6cb", base0D = "#59c2ff", base0E = "#d2a6ff", base0F = "#e6b673",
  })
  ```
- `undefined`: `require('tinted-colorscheme').setup()`

#### Config Parameter (optional)

| Key          | Type    | Description                                                                       |
| ------------ | ------- | --------------------------------------------------------------------------------- |
| `supports`   | `table` | Controls external sources for color selection                                     |
| `highlights` | `table` | Enables or disables plugin integrations and highlight groups (Enabled by default) |

##### `supports` Options

| Key            | Default | Description                                                                                |
| -------------- | ------- | -------------------------------------------------------------------------------------------|
| `tinty`        | `true`  | If `true`, attempts to use current [Tinty] theme if available                              |
| `tinted_shell` | `false` | If `true`, allows detection from `BASE16_THEME` env var (only outside tmux)                |
| `live_reload`  | `true`  | If `true`, open Neovim instances live reloads whenever [Tinty] applies a theme system-wide |

##### `highlights` Options

| Key                 | Default | Description                                    |
| ------------------- | ------- | ---------------------------------------------- |
| `telescope`         | `true`  | Enables Telescope highlight groups             |
| `telescope_borders` | `false` | Enables borders in Telescope                   |
| `indentblankline`   | `true`  | Enables indent-blankline.nvim highlight groups |
| `notify`            | `true`  | Enables nvim-notify highlights                 |
| `ts_rainbow`        | `true`  | Enables rainbow brackets via Treesitter        |
| `cmp`               | `true`  | Enables nvim-cmp highlight groups              |
| `illuminate`        | `true`  | Enables vim-illuminate highlights              |
| `lsp_semantic`      | `true`  | Enables semantic token highlights from LSP     |
| `mini_completion`   | `true`  | Enables highlights for mini.completion         |
| `dapui`             | `true`  | Enables highlights for nvim-dap-ui             |

**Example**:

```lua
require("tinted-colorscheme").setup("base16-ayu-dark", {
  supports = {
    tinty = true,
    tinted_shell = false,
  },
  highlights = {
    telescope = true,
    telescope_borders = false,
    indentblankline = true,
    notify = true,
    cmp = true,
    ts_rainbow = true,
    illuminate = true,
    lsp_semantic = true,
    mini_completion = true,
    dapui = true,
  }
})
```

You can access the Base16 and Base24 colors **after** setting the colorscheme by
name (`base01`, `base02`, ..., `base17`)

```lua
local red = require('tinted-colorscheme').colors.base08
```

### 🎨 Tinty

`.setup()` will use the current [Tinty] theme, which is retrieved from `tinty
current` command. If Tinty is not installed or `tinty current` does not return
a value, "tinted-nvim-default" (`base16-ayu-dark`) will be used as a fallback
theme. Ensure you have "tinted-nvim" added to your Tinty config (usually
`~/.config/tinted-theming/tinty/config.toml` but `tinty config --config-path`
with print the actual path):

```toml
[[items]]
path = "https://github.com/tinted-theming/tinted-nvim"
name = "tinted-nvim"
themes-dir = "colors"
supported-systems = ["base16", "base24"]
```

To have tinted-nvim automatically update the theme when `tinty apply ayu-dark`
is run, you can enable the live-reload feature.

**NVIM lua script:**
```lua
local tinted = require('tinted-colorscheme')
tinted.setup(nil, {
  supports = {
    live_reload = true
  }
})
```

> [!NOTE]
> If you don't see colours, try adding `vim.opt.termguicolors = true` to
> your init.lua

Have a look at [Tinted Gallery] for a preview of our themes.
## Advanced Usage

### Config

```lua
-- To disable highlights for supported plugin(s), call the `with_config` function **before** setting the colorscheme.
-- These are the defaults.
require('tinted-colorscheme').with_config({
    supports = {
      tinty = true,
      tinted_shell = false,
      live_reload = true,
    },
    highlights = {
      telescope = true,
      indentblankline = true,
      notify = true,
      ts_rainbow = true,
      cmp = true,
      illuminate = true,
      dapui = true,
    }
})
```

### Live Reload

If you have both `tinty` and `live_reload` enabled, the colorscheme will automatically update whenever you change
your theme system-wide with `tinty apply <SCHEME>`. 

The user event `TintedColorsPost` is triggered whenever the colorscheme changes. This is useful for when you want to
do something whenever the colorscheme live-reloads for example, such as applying some highlights yourself. You're able
to access the color-table from the `tinted-colorscheme` module:

```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "TintedColorsPost",
  callback = function()
    -- Do things whenever the theme changes.
    local colors = require("tinted-colorscheme").colors
    -- e.g. colors.base00, colors.base01, ... colors.base0F
  end,
})
```

## 🗂️ Builtin Colorschemes

You can use any of the following schemes with `:colorscheme` (for example
`:colorscheme base16-ayu-dark`):

```txt
base16-0x96f
base16-3024
base16-apathy
base16-apprentice
base16-ashes
base16-atelier-cave-light
base16-atelier-cave
base16-atelier-dune-light
base16-atelier-dune
base16-atelier-estuary-light
base16-atelier-estuary
base16-atelier-forest-light
base16-atelier-forest
base16-atelier-heath-light
base16-atelier-heath
base16-atelier-lakeside-light
base16-atelier-lakeside
base16-atelier-plateau-light
base16-atelier-plateau
base16-atelier-savanna-light
base16-atelier-savanna
base16-atelier-seaside-light
base16-atelier-seaside
base16-atelier-sulphurpool-light
base16-atelier-sulphurpool
base16-atlas
base16-ayu-dark
base16-ayu-light
base16-ayu-mirage
base16-aztec
base16-bespin
base16-black-metal-bathory
base16-black-metal-burzum
base16-black-metal-dark-funeral
base16-black-metal-gorgoroth
base16-black-metal-immortal
base16-black-metal-khold
base16-black-metal-marduk
base16-black-metal-mayhem
base16-black-metal-nile
base16-black-metal-venom
base16-black-metal
base16-blueforest
base16-blueish
base16-brewer
base16-bright
base16-brogrammer
base16-brushtrees-dark
base16-brushtrees
base16-caroline
base16-catppuccin-frappe
base16-catppuccin-latte
base16-catppuccin-macchiato
base16-catppuccin-mocha
base16-chalk
base16-chicago-day
base16-chicago-night
base16-circus
base16-classic-dark
base16-classic-light
base16-codeschool
base16-colors
base16-cupcake
base16-cupertino
base16-da-one-black
base16-da-one-gray
base16-da-one-ocean
base16-da-one-paper
base16-da-one-sea
base16-da-one-white
base16-danqing-light
base16-danqing
base16-darcula
base16-darkmoss
base16-darktooth
base16-darkviolet
base16-decaf
base16-deep-oceanic-next
base16-default-dark
base16-default-light
base16-digital-rain
base16-dirtysea
base16-dracula
base16-edge-dark
base16-edge-light
base16-eighties
base16-embers-light
base16-embers
base16-emil
base16-equilibrium-dark
base16-equilibrium-gray-dark
base16-equilibrium-gray-light
base16-equilibrium-light
base16-eris
base16-espresso
base16-eva-dim
base16-eva
base16-evenok-dark
base16-everforest-dark-hard
base16-everforest-dark-soft
base16-everforest
base16-flat
base16-framer
base16-fruit-soda
base16-gigavolt
base16-github-dark
base16-github
base16-google-dark
base16-google-light
base16-gotham
base16-grayscale-dark
base16-grayscale-light
base16-greenscreen
base16-gruber
base16-gruvbox-dark-hard
base16-gruvbox-dark-medium
base16-gruvbox-dark-pale
base16-gruvbox-dark-soft
base16-gruvbox-dark
base16-gruvbox-light-hard
base16-gruvbox-light-medium
base16-gruvbox-light-soft
base16-gruvbox-light
base16-gruvbox-material-dark-hard
base16-gruvbox-material-dark-medium
base16-gruvbox-material-dark-soft
base16-gruvbox-material-light-hard
base16-gruvbox-material-light-medium
base16-gruvbox-material-light-soft
base16-hardcore
base16-harmonic16-dark
base16-harmonic16-light
base16-heetch-light
base16-heetch
base16-helios
base16-hopscotch
base16-horizon-dark
base16-horizon-light
base16-horizon-terminal-dark
base16-horizon-terminal-light
base16-humanoid-dark
base16-humanoid-light
base16-ia-dark
base16-ia-light
base16-icy
base16-irblack
base16-isotope
base16-jabuti
base16-kanagawa-dragon
base16-kanagawa
base16-katy
base16-kimber
base16-lime
base16-macintosh
base16-marrakesh
base16-materia
base16-material-darker
base16-material-lighter
base16-material-palenight
base16-material-vivid
base16-material
base16-measured-dark
base16-measured-light
base16-mellow-purple
base16-mexico-light
base16-mocha
base16-monokai
base16-moonlight
base16-mountain
base16-nebula
base16-nord-light
base16-nord
base16-nova
base16-ocean
base16-oceanicnext
base16-one-light
base16-onedark-dark
base16-onedark
base16-outrun-dark
base16-oxocarbon-dark
base16-oxocarbon-light
base16-pandora
base16-papercolor-dark
base16-papercolor-light
base16-paraiso
base16-pasque
base16-penumbra-dark-contrast-plus-plus
base16-penumbra-dark-contrast-plus
base16-penumbra-dark
base16-penumbra-light-contrast-plus-plus
base16-penumbra-light-contrast-plus
base16-penumbra-light
base16-phd
base16-pico
base16-pinky
base16-pop
base16-porple
base16-precious-dark-eleven
base16-precious-dark-fifteen
base16-precious-light-warm
base16-precious-light-white
base16-primer-dark-dimmed
base16-primer-dark
base16-primer-light
base16-purpledream
base16-qualia
base16-railscasts
base16-rebecca
base16-rose-pine-dawn
base16-rose-pine-moon
base16-rose-pine
base16-saga
base16-sagelight
base16-sakura
base16-sandcastle
base16-selenized-black
base16-selenized-dark
base16-selenized-light
base16-selenized-white
base16-seti
base16-shades-of-purple
base16-shadesmear-dark
base16-shadesmear-light
base16-shapeshifter
base16-silk-dark
base16-silk-light
base16-snazzy
base16-solarflare-light
base16-solarflare
base16-solarized-dark
base16-solarized-light
base16-spaceduck
base16-spacemacs
base16-sparky
base16-standardized-dark
base16-standardized-light
base16-stella
base16-still-alive
base16-summercamp
base16-summerfruit-dark
base16-summerfruit-light
base16-synth-midnight-dark
base16-synth-midnight-light
base16-tango
base16-tarot
base16-tender
base16-terracotta-dark
base16-terracotta
base16-tokyo-city-dark
base16-tokyo-city-light
base16-tokyo-city-terminal-dark
base16-tokyo-city-terminal-light
base16-tokyo-night-dark
base16-tokyo-night-light
base16-tokyo-night-moon
base16-tokyo-night-storm
base16-tokyo-night-terminal-dark
base16-tokyo-night-terminal-light
base16-tokyo-night-terminal-storm
base16-tokyodark-terminal
base16-tokyodark
base16-tomorrow-night-eighties
base16-tomorrow-night
base16-tomorrow
base16-tube
base16-twilight
base16-unikitty-dark
base16-unikitty-light
base16-unikitty-reversible
base16-uwunicorn
base16-valua
base16-vesper
base16-vice
base16-vulcan
base16-windows-10-light
base16-windows-10
base16-windows-95-light
base16-windows-95
base16-windows-highcontrast-light
base16-windows-highcontrast
base16-windows-nt-light
base16-windows-nt
base16-woodland
base16-xcode-dusk
base16-zenbones
base16-zenburn
base24-0x96f
base24-3024-day
base24-3024-night
base24-adventure-time
base24-alien-blood
base24-argonaut
base24-arthur
base24-atelier-sulphurpool
base24-ayu-light
base24-ayu
base24-banana-blueberry
base24-batman
base24-birds-of-paradise
base24-blazer
base24-blue-berry-pie
base24-blue-matrix
base24-bluloco-dark
base24-bluloco-light
base24-borland
base24-breeze
base24-broadcast
base24-brogrammer
base24-builtin-dark
base24-builtin-light
base24-builtin-pastel-dark
base24-builtin-solarized-dark
base24-builtin-solarized-light
base24-builtin-tango-dark
base24-builtin-tango-light
base24-catppuccin-frappe
base24-catppuccin-latte
base24-catppuccin-macchiato
base24-catppuccin-mocha
base24-chalk
base24-chalkboard
base24-challenger-deep
base24-ciapre
base24-clrs
base24-cobalt-neon
base24-cobalt2
base24-crayon-pony-fish
base24-cyberdyne
base24-dark-plus
base24-deep-oceanic-next
base24-deep
base24-desert
base24-dimmed-monokai
base24-dracula
base24-earthsong
base24-elemental
base24-elementary
base24-embarcadero
base24-encom
base24-espresso-libre
base24-espresso
base24-fideloper
base24-firefox-dev
base24-fish-tank
base24-flat
base24-flatland
base24-floraverse
base24-forest-blue
base24-framer
base24-front-end-delight
base24-fun-forrest
base24-galaxy
base24-github-dark
base24-github-light
base24-grape
base24-gruvbox-dark
base24-gruvbox-light
base24-hacktober
base24-hardcore
base24-highway
base24-hipster-green
base24-hivacruz
base24-homebrew
base24-hopscotch
base24-hurtado
base24-hybrid
base24-ic-green-ppl
base24-ic-orange-ppl
base24-idea
base24-idle-toes
base24-jackie-brown
base24-japanesque
base24-jellybeans
base24-jet-brains-darcula
base24-kibble
base24-lab-fox
base24-laser
base24-later-this-evening
base24-lavandula
base24-lovelace
base24-man-page
base24-material-dark
base24-material
base24-mathias
base24-medallion
base24-mission-brogue
base24-misterioso
base24-molokai
base24-mona-lisa
base24-monokai-vivid
base24-mountain
base24-night-lion-v1
base24-night-lion-v2
base24-night-owlish-light
base24-nocturnal-winter
base24-obsidian
base24-ocean
base24-oceanic-material
base24-ollie
base24-one-black
base24-one-dark
base24-one-half-light
base24-one-light
base24-operator-mono-dark
base24-pandora
base24-paul-millr
base24-pencil-dark
base24-pencil-light
base24-piatto-light
base24-pnevma
base24-pro-light
base24-pro
base24-purple-rain
base24-purplepeter
base24-rebecca
base24-red-alert
base24-red-planet
base24-red-sands
base24-rippedcasts
base24-royal
base24-scarlet-protocol
base24-sea-shells
base24-seafoam-pastel
base24-shades-of-purple
base24-shaman
base24-slate
base24-sleepy-hollow
base24-smyck
base24-soft-server
base24-solarized-dark-higher-contrast
base24-solarized-dark-patched
base24-space-gray-eighties-dull
base24-space-gray-eighties
base24-spacedust
base24-sparky
base24-spiderman
base24-square
base24-sundried
base24-tango-adapted
base24-tango-half-adapted
base24-terminal-basic
base24-thayer-bright
base24-the-hulk
base24-toy-chest
base24-treehouse
base24-twilight
base24-ubuntu
base24-ultra-violet
base24-under-the-sea
base24-unikitty
base24-vibrant-ink
base24-violet-dark
base24-violet-light
base24-warm-neon
base24-wez
base24-wild-cherry
base24-wombat
base24-wryan
base24-zenburn
```

## Mentions

This repository is forked from [base16-nvim], special thanks to all the
contributors for work they've done.

[Tinty]: https://github.com/tinted-theming/tinty
[Tinted Gallery]: https://tinted-theming.github.io/tinted-gallery/
[base16-nvim]: https://github.com/RRethy/base16-nvim
